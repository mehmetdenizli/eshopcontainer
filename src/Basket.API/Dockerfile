FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
RUN apt-get update && apt-get install -y protobuf-compiler
COPY . .
WORKDIR /src/src/Basket.API
RUN dotnet publish -c Release -o /app/publish -p:Protobuf_ProtocFullPath=/usr/bin/protoc

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Basket.API.dll"]
