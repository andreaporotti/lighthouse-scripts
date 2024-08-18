# Lighthouse Scripts

Run Lighthouse desktop and mobile analysis on multiple URLs at once.

The script is available for **Powershell** (tested on Windows 10) and **Bash** (tested on Linux Mint 20).

## Requirements

### 1. Google Chrome

The browser must be installed on the system.

On Windows, a portable version can be used by creating this environment variable:
 - name: `CHROME_PATH`
 - value: `path to the Chrome folder including "chrome.exe"`

### 2. Node 18 LTS (18.x) or later

### 3. Lighthouse CLI

Global installation:

```
npm install -g lighthouse
```

### 4. Test

To check that everything is working, scan a random URL:

```
lighthouse https://github.com/
```

At the end you should get an HTML report.

## Using the script

Download or clone this repository in a folder.

If you are going to use the Bash version, make the script executable:

```
chmod u+x lh.sh
```

Copy or rename the file `lh_list-example.txt` to `lh_list.txt`.

Open the file `lh_list.txt` and add the URLs you need to analyze:
 - empty lines are ignored.
 - lines starting with `#` can be used as comments or to "deactivate" some URLs.

Optionally, customize the commands for desktop and mobile scan:
- open the script file
- locate the comment `# Setup Lighthouse commands`

For more details about the `lighthouse` command check the [official documentation](https://github.com/GoogleChrome/lighthouse?tab=readme-ov-file#using-the-node-cli).

By default the desktop command will use a screen width of "1440px", while the mobile one is set to "360px".

Run the script:

```
./lh.sh
```

or

```
.\lh.ps1
```

During script execution you should see an output like this:

```
Scanning url: https://github.com/ (DESKTOP)
Scanning url: https://github.com/ (MOBILE)
Scanning url: https://github.com/features (DESKTOP)
Scanning url: https://github.com/features (MOBILE)
...
```

When the script execution ends you should have two HTML reports for each URL.
