FROM mcr.microsoft.com/powershell:7.4-alpine-3.17

RUN apk add --no-cache aws-cli

ENTRYPOINT [ "pwsh", "-File", "./files/GetAMIUsageForCurrentAccount.ps1" ]