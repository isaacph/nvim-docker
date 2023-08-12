# nvim-docker
General Ubuntu docker nvim setup

## Using Docker:
```
docker create -f Dockerfile -t neovim
docker run -v .:/home/devuser/output -it neovim
# devuser password is placeholderpassword
```

## Authenticating with Github

I added ```gh``` for this:
```
gh auth login
# follow instructions
```
