#  # Expón el puerto 5154

# # Usa la imagen base de SDK de .NET 6.0 para compilar la aplicación
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /scr
# # COPY ["./MiAppWebv3_minimal/MiAppWebv3_minimal.csproj", "MiAppWebv3_minimal/"]
# # RUN dotnet restore "MiAppWebv3_minimal/MiAppWebv3_minimal.csproj"
# COPY . .

# RUN  pwd && ls -ltr 
# EXPOSE 5154 
# ENTRYPOINT ["dotnet run"]


# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
# WORKDIR /app
# EXPOSE 5154

# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY ["MiAppWebv3_minimal.csproj", "."]
# RUN dotnet restore "./MiAppWebv3_minimal.csproj"
# COPY . .
# WORKDIR "/src/."
# RUN dotnet build "MiAppWebv3_minimal.csproj" -c Release -o /app/build

# FROM build AS publish
# RUN dotnet publish "MiAppWebv3_minimal.csproj" -c Release -o /app/publish /p:UseAppHost=false

# FROM base AS final
# WORKDIR /app
# COPY --from=publish /app/publish .
# ENTRYPOINT ["dotnet", "MiAppWebv3_minimal.dll"]


# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /webapp
# EXPOSE 80
# EXPOSE 5154

# #COPY PROJECT FILES
# COPY ./*.csproj ./
# RUN dotnet restore

# #COPY EVERYTHONG ELSE
# COPY . .
# RUN ls -ltr
# RUN dotnet publish -c Release -o /out
# # RUN dotnet build "MiAppWebv3_minimal.csproj" -c Release -o /out

# # #BUILD IMAGE
# # FROM mcr.microsoft.com/dotnet/sdk:6.0
# # WORKDIR /webapp
# # COPY --from=build /webapp/out .
# ENTRYPOINT ["dotnet", "./out/MiAppWebv3_minimal.dll"]

# #docker build -t dotnetcoreapp .
# #docker run -d -p 5154:5154 --name webappnet dotnetcoreapp

# Utiliza la imagen base de SDK de .NET 6.0 para compilar la aplicación
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /webapp
EXPOSE 80
EXPOSE 5154

# Copia los archivos de proyecto .csproj y restaura las dependencias
COPY *.csproj ./
RUN dotnet restore

# Copia todo el contenido del proyecto y publica la aplicación
COPY . .
RUN dotnet publish -c Release -o /out

# Configura la imagen final para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:6.0   
# Utiliza la imagen aspnet
WORKDIR /app
COPY --from=build /out .

# Configura la variable de entorno ASPNETCORE_URLS para cambiar el puerto
ENV ASPNETCORE_URLS http://*:5154   # Configura el puerto 5154
ENTRYPOINT ["dotnet", "MiAppWebv3_minimal.dll"]

# dotnet publish -c Release -o ./out 
# dotnet .\out\MiAppWebv3_minimal.dll --urls "http://localhost:5154"