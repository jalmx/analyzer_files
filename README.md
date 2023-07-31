# Analyzer files

Busca todos los archivos, obtiene su hash, lo almacena y compara todos los archivos para ver si existe repetidos
en caso que existan repetidos, lo indica en un archivo, con su nombre y ruta, los que son iguales en su hash

## How to use


```bash
# It will search inside the path and exclude all files .gitignore and archivo.txt
analyzer <path> -x ".gitignore,archivo.txt" -r
```

```bash
# It will search inside the path, this help to know if you have the same files in your libs
analyzer <path> $HOME/Arduino -r  
```

```bash
# It will search inside the path and exclude all files .gitignore and folder node_modules
analyzer <path> -x ".gitignore,node_modules" -r
```


## Help

```bash
    --help                                Provide help
-p, --path=</home/>                       path to search
                                          (defaults to ".")
-r, --recursive                           Search into directory
-h, --hash                                
          [all]                           Apply all hashes
          [md5]                           Hash MD5
          [sha256] (default)              Hash SHA256

-x, --exclude=<node_module,.gitignore>    List of folders or files to exclude in search
                                          Example
                                           -x "node_module,.gitignore,*.txt"
-o, --output=<csv>                        Type of file to save the information

          [csv]                           Save file csv
          [json]                          Save file array json
          [sqlite]                        Save in db SQLite
          [stdout] (default)              Throw to terminal
```

## Install in Linux

You have in your `PATH` => `$USER/.local/bin` 

Install to `$USER/.local/bin`

```bash
# download bin
wget https://raw.githubusercontent.com/jalmx/analyzer_files/master/release/analyzer_lastest -O $HOME/.local/bin/analyzer

# Make executable
sudo chmod +x /$HOME/.local/bin/analyzer
```

## Steps to create a bin

Download repository

```bash
git clone https://github.com/jalmx/analyzer_files
```
Change to folder

```bash
cd ./analyzer_files
```

Download the dependencies

```bash
dart pub get
```

Compile to bin

```bash
dart compile exe bin/main.dart
```
