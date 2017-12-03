mirror-helper
============
Tools that makes creating mirror eaiser.

## Apply to your repo
1. Copy `*.sh` to your repo root directory.
2. Edit `config.sh`, change `REPOS` to your repo.
    * `code_name` is a directory name under `dists/`
    * `channel_name` is a directory name under `dists/<code_name>/`
    * `repo_name` is a combination of `<code_name>/<channel_name>`
3. Edit `<code_name>/config.sh`, change settings to your version.

## Build repo
1. `cd <your-repo-directory>`
2. `./make-current-mirror`
