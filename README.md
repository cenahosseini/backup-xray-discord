# Backup-XRay-Discord

## 1 - Installation :

 - for (x-ui):
```bash
wget https://raw.githubusercontent.com/SinaBigSmoke/backup-xray-discord/main/SinaBigSmoke_xui.sh
```

 - for (marzban):

```bash
wget https://raw.githubusercontent.com/SinaBigSmoke/backup-xray-discord/main/SinaBigSmoke_marzban.sh
```

 - for (hiddify):

```bash
wget https://raw.githubusercontent.com/SinaBigSmoke/backup-xray-discord/main/SinaBigSmoke_hiddify.sh
```

## 2 - Determine access:

 - for x-ui:
```bash
chmod +x SinaBigSmoke_xui.sh
```

 - for marzban:
```bash
chmod +x SinaBigSmoke_marzban.sh
```

 - for hiddify:
```bash
chmod +x SinaBigSmoke_hiddify.sh
```

## 3- To run:

 - for x-ui:
```bash
./SinaBigSmoke_xui.sh
```

 - for marzban:
```bash
./SinaBigSmoke_marzban.sh
```

 - for hiddify:
```bash
./SinaBigSmoke_hiddify.sh
```

## As a guide, you can add this description to the cron entry for scheduling:

1. Minutes: Enter a number between 0 and 59.
2. Hour: Enter a number between 0 and 23.
3. Day of the month: Enter a number between 1 and 31.
4. Month: Enter a number between 1 and 12.
5. Day of the week: Enter a number between 0 and 7 (0 and 7 refer to the same day of the week, which typically means Sunday).

### For example:

- To schedule a cron job every day at 10:30 AM, you can enter: `30 10 * * *`.
- To schedule a cron job every minute, you can enter: `* * * * *`.
- To schedule a cron job every Sunday at 8 PM, you can enter: `0 20 * * 0`.
