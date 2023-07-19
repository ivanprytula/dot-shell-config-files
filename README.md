# dot-shell-config-files

Classic collection of software engineer.

> Use the `--help` option, programmer (c)

General purpose: repo-cheatsheet for and with examples of ...

1. System service, shell commands, aliases, options, e.g. `systemctl`, `service`, `sudo`, `kill`, `find`, `mount` etc. _Amazing site:_ [https://explainshell.com/](https://explainshell.com/)
2. CLI options/arguments for Python tools, e.g. linters, formatters, type checkers etc.
3. dotfiles, e.g. `.env`, `env.example`, `.bashrc`, `.pre-commit-config.yaml` etc.
4. Config files, e.g. `setup.cfg`, `pyproject.toml` etc.
5. GitHub Actions workflow examples for quick reference & copy-paste
6. Typical repo files, e.g. `LICENSE`, `CONTRIBUTORS.txt` etc.
7. VSCode user/workspace settings

---

TOC

- [dot-shell-config-files](#dot-shell-config-files)
  - [System service, shell commands, aliases](#system-service-shell-commands-aliases)
    - [Often used](#often-used)
    - [Kill process on port](#kill-process-on-port)
    - [Export var into shell](#export-var-into-shell)
    - [Battery life](#battery-life)
    - [Disk usage](#disk-usage)
    - [Current system’s timezone](#current-systems-timezone)
    - [Permissions](#permissions)
    - [Different](#different)
  - [Git](#git)
  - [Python frameworks/libs/linters/formatters](#python-frameworkslibslintersformatters)
    - [Django](#django)
    - [Use black](#use-black)
    - [Use pytest](#use-pytest)
    - [Use flake8](#use-flake8)
    - [Task Runners, Build tools \& Pipelines](#task-runners-build-tools--pipelines)
  - [Databases](#databases)
  - [Containers/orchestration](#containersorchestration)
    - [Docker Engine](#docker-engine)
    - [Docker Compose](#docker-compose)
    - [k8s](#k8s)
  - [Other programming languages](#other-programming-languages)
    - [Ruby](#ruby)

## System service, shell commands, aliases

### Often used

```shell
man man
alias git st='git status'
ls
ls -la --human-readable
ls | head
ls -l; echo "hello"
ls -l && echo "hello"
lsusb
cd
cd ..
cd ../..
cd -
pwd
uname -ra
who
whoami
date
time
uptime
du
reset
ctrl+l
reboot
cp
mv
cat -b hello.txt
cat /etc/*-release
tail -n, --lines=[+]NUM 5 hello.txt
head -n, --lines=[-]NUM 5 hello.txt
more
less
env
echo "Hello"
echo "Hello" > hello.txt
echo $(pwd)
history
!2023
ctrl+u
ctrl+a
ctrl+e
ctrl+ arrow left/right
export PATH=/home/username/.local/bin:$PATH
top
pushd .
popd
vi /etc/ssh/sshd_config  # Esc -> :q
nano /etc/ssh/sshd_config
sudo !!
find -name "docker-*"
touch hello.txt
mkdir test
truncate --size 0 hello.txt
host localhost
```

1. `cd -` : back to the last directory we've been to.
2. `ctrl+l`: clear screen
3. `reset`: clear on steroids - resets terminal session
4. `pushd /var` + few other `cd` commands + `popd`: commands that allow you to work with directory stack and change the current working directory
5. `vim /etc/ssh/sshd_config` + ctrl+fz (if nano -> ctrl+tz) : isn't closing, but minimizing the window to the back ground
   1. `fg` : bring back the window to the front.
6. `apt update`: would fail - cuz we forgot sudo
   1. `sudo !!` : would run the last command as sudo
7. `ctrl+r` : "(reverse-i-search)_apt_: sudo _apt_ update" -> type what you want to find, press `ctrl+r` until you find, then `Enter`
8. run command that already been run - `history`, choose a number of command and run it `!102` -> the 102 command from the history would run again
9. HISTTIMEFORMAT="%Y-%m-%d %T " : `history` would show the history commands by the format.
   another way to add the format, is add it to the `~/.bashrc` file with `vim` or `nano` commands.
10. cmatrix -> let you look cool + ctrl c to escape
11. adjust font up `ctrl+shift +` or down `ctrl -`, `reset` command would reset the font size
12. line navigation:
    1. `ctrl a` - go to the start of the line
    2. `ctrl e` - got to the end of the line
    3. `ctrl u` - delete whole line
13. chaining commands -> `ls -l; echo "hello"` or -> `ls -l && echo "hello"` && - would stop when meets an error `;` - would pop up an error and keep on running the second/next command
14. `tail` / `head` commands to see top or bottom of a file.
    1. `tail -f /var/log/syslog` : monitor in real-life time
15. truncate (be cautious while using this one - its risky) : it allows to change the size of a very large files (like log files) or example `truncate -s <size_of_file> <name_of_file>` == truncate -s 0 hello.txt to empty the hello.txt file
16. `mount | column -t` : make sure all the output shows in columns any verbose and messy command output would look better using `| column -t`

### Kill process on port

```shell
sudo lsof -i -P -n | grep <port number> # List who's using the port
kill -9 <process id> (macOS) or sudo kill <process id> (Linux)

# e.g.
sudo lsof -i -P -n | grep 5432
sudo kill -9 1234
```

### Export var into shell

```bash
#!/bin/bash

set -a
# Automatically mark new and altered variables to be exported to subsequent environments.
# set -o allexport

export DJANGO_READ_DOT_ENV_FILE=True

set +a
# set +o allexport
```

### Battery life

```shell
cd /sys/class/power_supply/BAT0/
cat uevent
```

### Disk usage

```shell
du -h --summarize --total
du -h --all --exclude="venv" --exclude=".idea" --exclude="htmlcov" --exclude=".git" --exclude=".pytest_cache" --exclude="tmp"
du -h -a/-s * | sort -h
```

### Current system’s timezone

```shell
timedatectl
```

### Permissions

```text

 U   G   W
rwx rwx rwx     chmod 777 filename
rwx rwx r-x     chmod 775 filename
rwx r-x r-x     chmod 755 filename
rw- rw- r--     chmod 664 filename
rw- r-- r--     chmod 644 filename

U = User
G = Group
W = World

r = Readable
w = writable
x = executable
- = no permission

# sudo chown -R username:usergroup directory
# or if already as root, grant to user with uid 1000
chown -R 1000:1000 migration_number.py

sudo chown -R ivanp:ivanp file_name

rwx rwx rwx = 111 111 111
rw- rw- rw- = 110 110 110
rwx --- --- = 111 000 000

and so on...

rwx = 111 in binary = 7
rw- = 110 in binary = 6
r-x = 101 in binary = 5
r-- = 100 in binary = 4

d is a directory

rwx the user has read, write, and execute permissions

rw- the group has read and write permissions

r– all others have read only permissions

-rw-r--r-- 12 ivan.prytula domain users 12.0K Apr 28 10:10 file_name
|[-][-][-]- [------] [---]
| | | | | | |
| | | | | | +-----------> 7. Group
| | | | | +-----------------------> 6. Owner
| | | | +------------------------------> 5. Alternate Access Method
| | | +--------------------------------> 4. Others Permissions
| | +-----------------------------------> 3. Group Permissions
| +--------------------------------------> 2. Owner Permissions
+----------------------------------------> 1. File Type
```

### Different

```shell
openssl rand -hex 32

chmod +x ./setup-scripts/*.sh

```

## Git

- <https://devopscube.com/set-git-upstream-respository-branch/>

```shell

git init # inside project directory
git config --global user.name "Your Name"
git config --global user.email you@example.com
git status
git log
git diff

git remote add upstream https://github.com/devopscube/vagrant-examples.git
git branch --remotes

git add [filepath] # *stage the file, ready for commit*
git add .
git commit -am "message"
git push -u origin <new_branch>

git push origin main

git reset --soft HEAD~1

git log --follow -p -- pyproject.toml
```

```shell
# Rebase flow
git rebase -i HEAD~4

p sha1
p sha2
s sha3
s sha4
# will squash 2, 3 and 4 commits into one >>> we need do `push --force`
```

## Python frameworks/libs/linters/formatters

```shell
#!/bin/bash

# find Django path in env
python3 -c "import django; print(django.__path__)"

./manage.py migrate --check

source "$( poetry env list --full-path | grep Activated | cut -d' ' -f1 )/bin/activate"
```

### Django

```shell
CREATE DATABASE project_db_name;
CREATE USER project_db_user WITH PASSWORD 'super_password';
ALTER ROLE project_db_user SET client_encoding TO 'utf8';
ALTER ROLE project_db_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE project_db_user SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE project_db_name TO project_db_user;
```

### Use black

```shell
black <file_name.py> --check

# -S, --skip-string-normalization: Don't normalize string quotes or prefixes.
black <file_name.py> -S

#  --diff Don't write the files back, just output a
#                                  diff for each file on stdout.
# --color / --no-color            Show colored diff. Only applies when
#                                  `--diff` is given.
black --diff --color main.py
# Format all files in dir
black .

```text
https://naereen.github.io/badges/

## Use bandit

```shell
bandit -c pyproject.toml -r quiz/
```

### Use pytest

```shell
# run all tests
$ python -m pytest tests

# run tests in `chat` directory
$ python -m pytest tests/chat

# run only the quiz tests
$ python -m pytest tests/quiz/test_question_models.py

# run 2 tests concurrently
python -m pytest tests -n 2
```

### Use flake8

The error code of flake8 are E***, W*** used in pep8 and F*** and C9**.

E***/W***: Error and warning of pep8
F***: Detection of PyFlakes
C9**: Detection of circulate complexity by McCabe

```shell
flake8 <file_name.py>
```

```python
# flake8: noqa
```

### Task Runners, Build tools & Pipelines

- `doit`
- `make`
- plain `bash` script
- `pypyr`

## Databases

```shell
# For a interactive login shell as `postgres` user
sudo -u postgres -i

# is !! preferable to... sudo su - postgres

postgres@ws-lv-cp3528:~$ psql
psql (15.1 (Ubuntu 15.1-1.pgdg22.04+1), server 14.6 (Ubuntu 14.6-1.pgdg22.04+1))
Type "help" for help.

postgres=# \du # show all users
postgres=# CREATE DATABASE db_foo_name;
postgres=# \c db_foo_name # You are now connecting to database as user "postgres"
postgres=# \dt # listing tables
postgres=# \d+ <table_name> # show table columns

# command execution
sudo -u postgres psql -c "SELECT 1"

# Use systemctl/service/other commands to manage postgresql service:
# Initialize the server by running the command:
sudo service postgresql initdb

# 1. START
# all
systemctl start postgresql
sudo service postgresql start

# start specific server
systemctl start postgresql@14-main
sudo service postgresql start
sudo service postgresql-14.2 start

## 2. STOP
systemctl stop postgresql
service postgresql stop

# 3. STATUS
systemctl status postgresql@14-main
service postgresql status
pgrep -u postgres -fa -- -D

# show information about all PostgreSQL clusters
pg_lsclusters

# 4. DISABLE (not auto-start any more)
systemctl disable postgresql

# 5. ENABLE (auto-start)
systemctl enable postgresql
systemctl enable postgresql@14-main

# Find PostgreSQL location
sudo find /usr -wholename '*/bin/postgres'

# Find your port
# example: sudo sed -n 4p <$PGDATA>/postmaster.pid
sudo sed -n 4p /var/lib/postgresql/14/main/postmaster.pid

# Control cluster startup
cat /etc/postgresql/14/main/start.conf
```

## Containers/orchestration

### Docker Engine

````shell
[sudo] systemctl (start|stop|restart) docker

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Rootless Docker mode
## deamon

```shell
# Use systemctl --user to manage the lifecycle of the daemon:
systemctl --user start docker

# To launch the daemon on system startup, enable the systemd service and lingering:
systemctl --user enable docker
sudo loginctl enable-linger $(whoami)

## client
```shell
# To specify the socket path using $DOCKER_HOST:
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
docker run -d -p 8080:80 nginx

# To specify the CLI context using docker context:
docker context use rootless
docker run -d -p 8080:80 nginx

# Stop and remove containers
docker-compose down  # Stop container on current dir if there is a docker-compose.yml
docker rm -fv $(docker ps -aq)  # Remove all containers

docker exec -it yournamecontainer psql -U postgres -c "CREATE DATABASE mydatabase ENCODING 'utf8' TEMPLATE template0 LC_COLLATE 'C' LC_CTYPE 'C';"

docker exec -it yournamecontainer psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO user_name;"

docker rmi -f $(docker images -f "dangling=true" -q)
````

### Docker Compose

```yaml
volumes:
  # Just specify a path and let the Engine create a volume
  - /var/lib/mysql

  # Specify an absolute path mapping
  - /opt/data:/var/lib/mysql

  # Path on the host, relative to the Compose file
  - ./cache:/tmp/cache

  # User-relative path
  - ~/configs:/etc/configs/:ro

  # Named volume
  - datavolume:/var/lib/mysql
```

```shell
cd scripts/local_docker && docker compose up -d redis && cd -
cd scripts/local_docker && docker compose stop && cd -

docker compose exec db psql
docker compose exec app python3
```

### k8s

```shell
snap info microk8s | grep installed
```

## Other programming languages

### Ruby

```shell
/usr/bin/zsh --login
rvm use 3.1.2
```
