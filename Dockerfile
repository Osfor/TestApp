#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["TestApp.csproj", "."]
RUN dotnet restore "./././TestApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./TestApp.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./TestApp.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
ENV cert_file=""
ENV priv_key_file=""
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestApp.dll", "--TestApp_Kestrel_Endpoints_HttpsInlineCertAndKeyFile_Certificate_Path=$cert_file", "--TestApp_Kestrel_Endpoints_HttpsInlineCertAndKeyFile_Certificate_KeyPath=$priv_key_file"]



