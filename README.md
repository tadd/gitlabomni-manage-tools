# GitLab Omnibus Management Tools

This is rarely maintained fork from [mizunashi-mana/gitlabomni-manage-tools](https://github.com/mizunashi-mana/gitlabomni-manage-tools) from [uecmma/gitlabomni-manage-tools](https://github.com/uecmma/gitlabomni-manage-tools).

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
