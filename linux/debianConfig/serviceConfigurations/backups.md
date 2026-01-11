This file explains different backup types and shows how to create, list, and extract backups using the `tar` command in Linux.
# Types
- Total- A complete backup of **all selected files and directories**, regardless of whether they have changed or not.
- Differential - A backup of files that have **changed since the last full backup**.
- Incremental - A backup of files that have **changed since the last backup** (either full or incremental).

# Tar

`tar` is a standard Unix/Linux tool used to **archive files and directories**.  
It is commonly used for backups, often combined with compression tools like **bzip2**.

|Parameter|Short description|Explanation|
|---|---|---|
|`c`|create|Creates a new archive|
|`v`|verbose|Shows the files being processed|
|`f`|file|Specifies the archive file name|
|`j`|bzip2|Compresses the archive using **bzip2**|
|`x`|extract|Extracts files from an archive|
|`t`|list|Lists the contents of an archive|
|`N`|newer|Includes only files newer than a given date

# Total

Creates a compressed archive containing **all specified folders**.

```powershell title="total"
tar -jcvf /aim_folder/name_total_`date +%d%b%y`.tar.bz2 /folder1 /folder2
```

# Differential

Creates a backup of files that have been **modified after a specific date** (usually the date of the last full backup).

```powershell title="total"
tar -jcvf /aim_folder/name_diferential_`date +%d%b%y`.tar.bz2 /folder1 /folder2 -N 01-Ene-10
```
# Incremental

These commands are used to **work with an existing backup**:


```powershell title="total - extract files"
tar -jxvf /aim_folder/name.tar.bz2
```

```powershell title="total - list archive contents"
tar -jtvf /aim_folder/name.tar.bz2
```

> Incremental backups usually rely on timestamps or snapshot files, but `tar` can still be used to manually handle them.