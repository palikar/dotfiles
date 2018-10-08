#!/usr/bin/python


import os, sys, argparse, json
import subprocess





install_cache = list()

def install_package(name, config, directory, reinstall=False):
    global install_cache
    package = config["packages"][name]

    #Check dependencies
    install_cache.append(name)
    if "dependencies" in package:
        for dep in package["dependencies"]:
           if dep in install_cache:
               print("Thers is a cirlucar dependency between packages. This is not allowed!")
               print(f"{name} depends on {dep} and the other way around.")
               exit(1)
           else:
               install_package(dep, config, directory, reinstall=reinstall)
    install_cache.remove(name)

    
    print(f"Installing {name}")
    
    last_edit = os.curdir
    package_dir = os.path.join(directory, name)

    if not os.path.isdir(package_dir):
        os.makedirs(package_dir)
    
    if len(os.listdir(package_dir)) != 0 and reinstall == False:
        print(f"The direcory ({package_dir}) is not empty and the package (name) is not in cache")
        print("Deleting direcotry\'s contents")
        os.system(f"rm -rf {package_dir}/* {package_dir}/.* 2> /dev/null")

    os.chdir(package_dir)
    
    if reinstall == False:
        print(f"Downloading {name}")
        if package["download"] == "git":
            print(f"Using git and cloning from {package['URL']}")
            print(f"Cloning into {os.path.abspath('.')}")
            os.system(f"git clone -q {package['URL']} .")
        elif package["download"] == "curl":
            print(f"Using curl and downloading from {package['URL']}")
            print(f"Downloading into {os.path.abspath(package_dir)}")
            os.system(f"curl -LOs {package['URL']} .")
        elif package["download"] == "wget":
            print(f"Using wget and downloading from {package['URL']}")
            print(f"Downloading into {os.path.abspath(package_dir)}")
            os.system(f"wget -q {package['URL']} .")
        

    
    if package["install"] == "script":
        print(f"Installing with script file")
        script = package["script"]
        script = os.path.expanduser(script)
        script = os.path.expandvars(script)
        script = os.path.abspath(script)
        print(f"Used script: {script}")
        cmd_args = package["script_args"] if "script_args" in package else ""
        cmd_args = os.path.expanduser(cmd_args)
        cmd_args = os.path.expandvars(cmd_args)
        cmd_args = cmd_args + " -r" if reinstall else ""
        print(f"Passed arguments to the script: {cmd_args}")
        os.system(f'sh {script} ' + cmd_args)
    elif package["install"] == "command":
        print(f"Installing with command")
        command = package["command"] if reinstall == False else package["reinstall_command"]
        command = os.path.expanduser(script)
        command = os.path.expandvars(script)
        print(f"Used command: {command}")
        os.system(f"{command}")

    os.chdir(last_edit)
    print("##############################")


def install(config, directory, packages):
    for pack in packages:
        if pack not in config["packages_list"]:
            print(f"Package {pack} is not in the config file")
        else:
            install_package(pack, config, directory)
        
    
    pass


def install_all(config, directory):
    packages = config["packages_list"]
    install(config, directory, packages)



def main():
    parser = argparse.ArgumentParser(description='Installs system packages from the INTERNET!!')

    parser.add_argument('--install', dest='packages',
                        help='Packages to install', nargs='+')
    
    parser.add_argument('--code-dir', dest='code_dir', action='store', required=True,
                    help='A folder to put the source of the packages')

    parser.add_argument('--install-all', dest='all', action='store_true',
                        help='Install all packages in system_packages.json')
    
    args = parser.parse_args()

    config = None
    with open("./system_packages.json") as config_file:
        config = json.load(config_file)

    if not args.code_dir:
        os.makedirs(args.code_dir)

    if args.all:
        install_all(config, args.code_dir)
    else:
        install(config, args.code_dir, args.packages)



if __name__ == '__main__':
    main()
