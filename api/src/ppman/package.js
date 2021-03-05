const logger = require('logplease').create('ppman/package');
const semver = require('semver');
const config = require('../config');
const globals = require('../globals');
const helpers = require('../helpers');
const path = require('path');
const fs = require('fs/promises');
const fss = require('fs');
const cp = require('child_process');
const crypto = require('crypto');
const runtime = require('../runtime');

class Package {
    constructor(repo, {author, language, version, checksums, dependencies, size, buildfile, download, signature}){
        this.author = author;
        this.language = language;
        this.version = semver.parse(version);
        this.checksums = checksums;
        this.dependencies = dependencies;
        this.size = size;
        this.buildfile = buildfile;
        this.download = download;
        this.signature = signature;

        this.repo = repo;

    }

    get installed(){
        return fss.exists_sync(path.join(this.install_path, globals.pkg_installed_file));
    }

    get download_url(){
        return helpers.add_url_base_if_required(this.download, this.repo.base_u_r_l);
    }

    get install_path(){
        return path.join(config.data_directory,
            globals.data_directories.packages,
            this.language,
            this.version.raw);
    }

    async install(){
        if(this.installed) throw new Error('Already installed');
        logger.info(`Installing ${this.language}-${this.version.raw}`);

        if(fss.exists_sync(this.install_path)){
            logger.warn(`${this.language}-${this.version.raw} has residual files. Removing them.`);
            await fs.rm(this.install_path, {recursive: true, force: true});
        }

        logger.debug(`Making directory ${this.install_path}`);
        await fs.mkdir(this.install_path, {recursive: true});


        logger.debug(`Downloading package from ${this.download_url} in to ${this.install_path}`);
        const pkgfile = helpers.url_basename(this.download_url);
        const pkgpath = path.join(this.install_path, pkgfile);
        await helpers.buffer_from_url(this.download_url)
            .then(buf=> fs.write_file(pkgpath, buf));

        logger.debug('Validating checksums');
        Object.keys(this.checksums).forEach(algo => {
            var val = this.checksums[algo];

            logger.debug(`Assert ${algo}(${pkgpath}) == ${val}`);

            var cs = crypto.create_hash(algo)
                .update(fss.read_file_sync(pkgpath))
                .digest('hex');
            if(cs != val) throw new Error(`Checksum miss-match want: ${val} got: ${cs}`);
        });

        await this.repo.import_keys();

        logger.debug('Validating signatures');

        if(this.signature != '')
            await new Promise((resolve,reject)=>{
                const gpgspawn = cp.spawn('gpg', ['--verify', '-', pkgpath], {
                    stdio: ['pipe', 'ignore', 'ignore']
                });

                gpgspawn.once('exit', (code, _) => {
                    if(code == 0) resolve();
                    else reject(new Error('Invalid signature'));
                });

                gpgspawn.once('error', reject);

                gpgspawn.stdin.write(this.signature);
                gpgspawn.stdin.end();
                
            });
        else
            logger.warn('Package does not contain a signature - allowing install, but proceed with caution');

        logger.debug(`Extracting package files from archive ${pkgfile} in to ${this.install_path}`);

        await new Promise((resolve, reject)=>{
            const proc = cp.exec(`bash -c 'cd "${this.install_path}" && tar xzf ${pkgfile}'`);
            proc.once('exit', (code,_)=>{
                if(code == 0) resolve();
                else reject(new Error('Failed to extract package'));
            });
            proc.stdout.pipe(process.stdout);
            proc.stderr.pipe(process.stderr);

            proc.once('error', reject);
        });

        logger.debug('Ensuring binary files exist for package');
        const pkgbin = path.join(this.install_path, `${this.language}-${this.version.raw}`);
        try{
            const pkgbin_stat = await fs.stat(pkgbin);
            //eslint-disable-next-line snakecasejs/snakecasejs
            if(!pkgbin_stat.isDirectory()) throw new Error();
            // Throw a blank error here, so it will be caught by the following catch, and output the correct error message
            // The catch is used to catch fs.stat
        }catch(err){
            throw new Error(`Invalid package: could not find ${this.language}-${this.version.raw}/ contained within package files`);
        }

        logger.debug('Symlinking into runtimes');

        await fs.symlink(
            pkgbin,
            path.join(config.data_directory,
                globals.data_directories.runtimes,
                `${this.language}-${this.version.raw}`)
        ).catch((err)=>err); //Ignore if we fail - probably means its already been installed and not cleaned up right
        

        logger.debug('Registering runtime');
        const pkg_runtime = new runtime.Runtime(this.install_path);

        
        logger.debug('Caching environment');
        const required_pkgs = [pkg_runtime, ...pkg_runtime.get_all_dependencies()];
        const get_env_command = [
            ...required_pkgs.map(pkg=>`cd "${pkg.runtime_dir}"; source environment; `),
            'env'
        ].join(' ');

        const envout = await new Promise((resolve, reject)=>{
            var stdout = '';
            const proc = cp.spawn('env',['-i','bash','-c',`${get_env_command}`], {
                stdio: ['ignore', 'pipe', 'pipe']});
            proc.once('exit', (code,_)=>{
                if(code == 0) resolve(stdout);
                else reject(new Error('Failed to cache environment'));
            });

            proc.stdout.on('data', (data)=>{
                stdout += data;
            });

            proc.once('error', reject);
        });

        const filtered_env = envout.split('\n')
            .filter(l=>!['PWD','OLDPWD','_', 'SHLVL'].includes(l.split('=',2)[0]))
            .join('\n');

        await fs.write_file(path.join(this.install_path, '.env'), filtered_env);

        logger.debug('Writing installed state to disk');
        await fs.write_file(path.join(this.install_path, globals.pkg_installed_file), Date.now().toString());

        logger.info(`Installed ${this.language}-${this.version.raw}`);

        return {
            language: this.language,
            version: this.version.raw
        };
    }
}


module.exports = {Package};