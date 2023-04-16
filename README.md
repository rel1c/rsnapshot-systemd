# rsnapshot-systemd

## Description

This tool enables a user to automatically create a set of systemd service files
for a rsnapshot backup scenario. Each service file will be conditionally ran
based on a systemd timer. This tool is intended to be used with systemd
shorthand calendar values, such as "hourly, "daily" and "yearly", and expects a
rsnapshot scenario to use the same intervals in a corresponding configuration
file.

### Inspiration

Right now, rsnapshot is bundled with a cron job, but not a systemd service
file. I find running rsnapshot as a systemd service is more useful for a backup
scenario than a simple cron job. Systemd services have nice support for logging
and error handling. The number one reason I run it as a service is chaining
backups based on intervals (daily, weekly, monthly, etc). This chaining is
accomplished with systemd service rules `Require` and `After` which ensures a
backup that is reliant on another backup has been ran, such as a daily before a
weekly backup. Without these service rules in using a cron job, I had to rely on
scripting the logic elsewhere or relying on a time gap between rsnapshot runs.

Another reason I wanted this tool was to automatically make service files for
separate configuration files. It is possible to run rsnapshot with a specific
configuration file, and sometimes I want to schedule multiple rsnapshot services
with different configurations at different times, such as a local backup once
every hour, but a remote backup once every day.
