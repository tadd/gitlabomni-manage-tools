# GitLab Omnibus Management Tools [![Travis Status][travis-image]][travis-url]

This is maintained fork from [uecmma/gitlabomni-manage-tools](https://github.com/uecmma/gitlabomni-manage-tools)

## Installation

See [Installation Document](doc/Installation.md).

## Usage

See `gitlab-manage help`

### Notify for cron job

```bash
gitlab-manage notify-cronjob
```

This command notifies you if new version was available.

* Mail Task: mailing the new version notification

### Update

```bash
gitlab-manage upgrade
```

Update gitlab omnibus package if new version was available.

[travis-image]: https://travis-ci.org/mizunashi-mana/gitlabomni-manage-tools.svg?branch=master
[travis-url]: https://travis-ci.org/mizunashi-mana/gitlabomni-manage-tools.svg?branch=master
