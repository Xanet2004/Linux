`crontab` is a Linux utility used to schedule tasks (jobs) to run automatically at specific times or intervals.

Each scheduled task is called a **cron job**.

# Crontab commands

```powershell title="edit crontab"
crontab -e
```

> It should open crontab configuration file

```powershell title="list crontab jobs"
crontab -l
```

```powershell title="remove crontab jobs"
crontab -r
```

# Crontab format

A cron job follows this structure:

```powershell title="crontab structure"
* * * * * command
| | | | |
| | | | └─ Day of week (0–7) (Sunday = 0 or 7)
| | | └─── Month (1–12)
| | └───── Day of month (1–31)
| └─────── Hour (0–23)
└───────── Minute (0–59)
  ```

# Special characters

|Symbol|Meaning|
|---|---|
|`*`|Any value|
|`,`|List of values (e.g. `1,3,5`)|
|`-`|Range of values (e.g. `1-5`)|
|`/`|Step values (e.g. `*/10`)|

---

## Examples

### Every day at 02:00

```powershell title="example 1"
0 2 * * * /path/script.sh
```

### Every 10 minutes

```powershell title="example 2"
*/10 * * * * /path/script.sh
```

### Every Monday at 08:30

```powershell title="example 3"
30 8 * * 1 /path/script.sh
```

### Every hour at minute 1

```powershell title="example 4"
1 * * * * /path/script.sh
```