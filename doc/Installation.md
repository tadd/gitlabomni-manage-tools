# Installation

## First, Install GitLab Omnibus

See https://docs.gitlab.com/omnibus/README.html#installation

Now, GitLab Omnibus supports only linux platform.
So, this manage tools also works only in one's platform.

## Then, deploying manage tools

Notice:

* Now, this manage tools support only manual deployment.
* Creating deb or rpm is working in progress.

1. Clone the manage tools:

    GitLab Omnibus installs embedding git with packages.
    We recommend to use this one.

    ```bash
    sudo /opt/gitlab/embedded/bin/git clone \
      https://github.com/mizunashi-mana/gitlabomni-manage-tools.git \
      /opt/gitlab-manage # install on `/opt/gitlab-manage` directory
    ```

2. Install requirement packages:

    ```bash
    cd /opt/gitlab-manage
    sudo env PATH=/opt/gitlab/embedded/bin:$PATH \
      bundle install --deployment --without development test
    sudo env PATH=/opt/gitlab/embedded/bin:$PATH \
      bundle binstub gitlabomni-manage-tools # create `bin/gitlab-manage` script
    ```

3. Create requirement directories:

    ```bash
    sudo mkdir -p \
      /etc/gitlab-manage \
      /var/lib/gitlab-manage/{data,cache}
    ```

4. Create custom proxy script:

    ```bash
    $ sudo sh -c 'cat > /usr/local/bin/gitlab-manage'
    #!/bin/sh

    export PATH="/opt/gitlab/embedded/bin:$PATH"

    exec /opt/gitlab-manage/bin/gitlab-manage $*
    $ sudo chmod +x /usr/local/bin/gitlab-manage
    $ gitlab-manage help # for checking
    ```

5. Create configuration(See, [Configuration Document](Configuration.md)):

    ```bash
    $ sudo sh -c 'cat > /etc/gitlab-manage/config.yaml'
    general:
      data_dir: /var/lib/gitlab-manage/data
      cache_dir: /var/lib/gitlab-manage/cache

    mail:
      enable: false

      host: localhost
      port: 25

      show_diff: true
    ```

6. Add cron task(Optional):

    ```bash
    $ sudo apt install -y cron
    $ sudo crontab -e -u root
    + 15 04 * * * /usr/local/bin/gitlab-manage notify-cronjob 2>&1 | /usr/bin/logger -t gitlab-manage
    ```
