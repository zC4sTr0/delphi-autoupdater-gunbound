<p  align="center"><img  src="preview/preview-mainform.png"  alt="PREVIEW"  ></p>
<h1  align="center">Delphi Updater Program</h1>
<div  align="center">
A beautiful auto updater program made in Delphi 7 to update files in source folder. 
<br/>  <br/>

</div>

<div Quick Links="center">
  <h3>Menu:<br>
    <a href="#preview">Preview</a><span> | </span>
    <a href="#features">Features</a><span> | </span>
    <a href="#how-to-run">How to Run</a><span> | </span>
    <a href="#about-me">About</a><span>
  </h3>
  <div align="center"><sub>Made with ❤︎ by <a href="https://github.com/zC4sTr0">Gabriel Castro</a> and <a href="https://github.com/samuelrizzo">Samuel Rizzo</a></sub></div>
</div>

# Preview

<img  src="preview/download-2.gif"  alt="UPDATER-PREVIEW-MAINFORM"/>
<img  src="preview/download-ok.gif"  alt="UPDATER-PREVIEW-MAINFORM2"/>
 
# Features

## Updater widely tested and with fast hash
The Updater with Blake hash algorithm has been carefully designed to ensure a smooth and efficient update process for GunBound GitzWC. The updater is written in Pascal and compiled with Delphi, and it has been extensively tested on over 3,000 computers worldwide.

## Thread Support
One of the key features of this updater is its support for threads, which allows for smooth file downloads without freezing the user interface. This means that users can continue to use their computers without interruption while the updater does its work.

## Supports Compressed ZIP Files with Passwords
The Delphi Updater also supports compressed ZIP files with passwords, which can be particularly useful in avoiding antivirus software issues during the download process. The extraction process is fast, but users may be able to achieve even better results by changing the compression algorithm.<br>
The Updater also extract the ZIP sucessfully (all with progress bars!)

## File Hash Check
To ensure that only the necessary files are updated, the Delphi Updater uses a file called "filelist.dat" which contains the names, sizes, and Blake-256 hashes of all the files required for the update. The updater compares the hashes of the files in the client folder with those in the filelist.dat file to ensure that the files are up-to-date and unmodified. This feature ensures that the update process is not only efficient but also secure.

## Blake Hash Algorithm

In order to ensure that files are up-to-date, the Delphi Updater uses the fast and accurate Blake-256 algorithm to calculate hashes. <br>
The Blake-256 hash algorithm is a cryptographic hash function that produces a 256-bit hash value. It was created by Jean-Philippe Aumasson, Samuel Neves, Zooko Wilcox-O'Hearn, and Christian Winnerlein. The algorithm is named after one of the creators, Jean-Philippe Aumasson's, newborn son Blake.

The Blake-256 algorithm is known for its speed and security. It has been extensively analyzed and tested, and is widely regarded as a secure and reliable hash function. The algorithm uses a combination of cryptographic techniques, including keying, message padding, and data compression, to produce its hash values.

In the context of the Updater, the Blake-256 hash algorithm is used to ensure the integrity and authenticity of the downloaded files. When a file is downloaded, the Delphi Updater calculates the hash value of the file using the Blake-256 algorithm. The calculated hash value is then compared to the expected hash value stored in the filelist.dat file. If the calculated hash value matches the expected hash value, the file is deemed to be authentic and can be installed. If the hash values do not match, the file is considered to be corrupt or tampered with, and the updater will not install it.

Overall, the Blake-256 hash algorithm is an excellent choice for ensuring the security and integrity of downloaded files. Its speed and reliability make it a popular choice in a variety of applications, including the Delphi Updater used in GunBound GitzWC.

In summary, the Delphi Updater with Blake hash algorithm is a powerful tool for updating files efficiently and quickly. Its support for threads and compressed ZIP files with passwords make it an excellent choice for anyone who wants to avoid issues that may arise during the download process, such as antivirus software problems.

## Background Image Support
The Delphi Updater supports a custom background image for the updater interface. If the image file exists in the same folder as the updater executable, it will be loaded and displayed as the background. This feature adds a nice touch of customization to the updater.

## Task Killing
The updater is able to kill specific processes before updating, which helps to ensure that there are no conflicts or issues with running programs. The following processes are targeted: "GitzGame.exe," "NyxLauncher.exe," "UpdaterReplacer.exe," and "GbSet.exe." Killing these processes helps to ensure a smooth update process.

## Multi-Language Support
The updater have support in English, Portugues and Spanish languages and it's very easy to add more languages.

## File Deletion
The updater also has the ability to delete files before updating, which can be useful in ensuring that old files are not left behind. The following files are deleted: ".tmp," ".bak," "*.gp," "replacelist.dat," and "filelist.dat."

## Updater.ini Creation
If the updater.ini file does not exist in the same folder as the updater executable, the updater will create it and save it. This file is used to configure the updater settings, such as the FTP host, user credentials, and update files.

# How to run

To run this applications, you must have Delphi 7 installed in your computer.

Read more about how to Install Delphi here: https://www.embarcadero.com/br/products/delphi/starter/free-download

Additionally, this program requires the installation of the ABBREVIA component package to use the AbUnzipper. <br>
This package is provided in the repository and can be found at 

`` ..\Abbrevia\packages\Delphi 7\Abbrevia.dpk. ``
  

_To install ABBREVIA in Delphi, follow these steps:_

  ![image](https://github.com/zC4sTr0/delphi-autoupdater-gunbound/assets/38432614/0936d082-4131-4ea2-ad79-e84358abf8af)
  
- Open ALL ABBREVIA packages (dpks) located in `` ..\Abbrevia\packages\Delphi 7\`` folder in Delphi and to each one do the following steps:
  
  - From the "Package" menu, select "Compile": ![image](https://github.com/zC4sTr0/delphi-autoupdater-gunbound/assets/38432614/d16dde07-1bea-4b87-9f06-bc0c00f49877)
  
  
  
  - If there are no errors, from the "Package" menu select "Install": ![image](https://github.com/zC4sTr0/delphi-autoupdater-gunbound/assets/38432614/a994fe2c-c6a2-4cac-a01c-551bb0da8b23)
  
  
  - If you see a dialog box telling you that it's not a design time package like this, just press ok. (it happens because this package shouldn't be installed, only compiled)
  
    ![image](https://github.com/zC4sTr0/delphi-autoupdater-gunbound/assets/38432614/ac84ba72-3264-471e-8518-91813bae513c)
  
  
Once the ABBREVIA package is installed, you should be able to run the program without issue. If you encounter any problems, please open an issue.

# Filelist.dat documentation

The filelist.dat file is used to store the names, sizes, and hashes of all the files required for the update. The filelist.dat file is used by the updater to ensure that only the necessary files are updated. The filelist.dat file is a text file that contains the following information:

- File name
- File size
- File Hash

Using the following format: Name#Size;Hash<br>
The separator is the # for the name and size, and the ; for the hash.<br>

The Size must be specified in bytes.<br>
If size is not correct, the file will not be successfully updated.

 Example (GITZWC):

```
UpdaterReplacer.exe#206025;aQ5c7aoRuH/Y3wbH8eepu1mbwAYt9XMAA+/zdkw7at8=
Updater.exe#1372200;/d1A0D9llGbUuFdlt5VpPMiX9048fI56FiajD0jyxf4=
launcher.dll#1084968;mGgy0cRVemVRbI5q6GeosLXunFslIa/cRDELAJXMuWk=
npqcrypt.dll#300266;7SSGRTvrHRJbE7u6mpevsXvai4xp13ggHRmXcHE5fwg=
NyxLauncher.exe#1168473;Whxr1xlRJpvo9IgOuNC2DQ9YLB0gaBRVc7AQwiL1IDY=
GunProtect.exe#435400;DRb4QED52OFnjRmG1oKT24E6/uRb9zdO39a3+9bKvYQ=
gitzgame.gme#5247528;rV9ls13yodoW/tr8XnaewuHK23o3v28j1CpwHnV2QJU=
GProtect.dll#9594160;0+NWuL+n9FZUJVyihReGs0WWL0Uqf9E9mRonA5/3Ujo=
GunProtectBG.png#342269;hyW4NFN02XvQ1Ts6L+CMT1WW0JB0BZM4zoQ4f6NmkW8=
NyxLauncher.dll#1168473;XmH6pfh8NMam0Vt8V3yyF+Orf1O2uw9h4cJlv/RvS28=
GitzWindowMode.dll#67624;TTSzyi2y9w0/ItH7lkjSSzvPlE4wHJurcyvp24yhKqA=
wndmode.ini#429;SwX5jdT8uCSiYh6cc2Kqd9sTZDVqNSzBdGysHDVM7yg=
dxwnd.dll#1164930;WUErEP6e5NiM1CUVhhO4VkDcVb51QwnyvhuwLPREfKw=
GbSet.exe#2821936;rUrguiZfQIv6iXMHHXtDkT3dna14EBSb19deLkUQVgw=
```

## How to generate the hashes:

I included the official Blake-256 hash generator in the repository(filelist Hash Generator, inside bin folder), but you can use any other hash generator to generate the hashes.<br>
To generate the hashes, you need to use the Blake-256 algorithm and encode the hash in base64.

There's probably tons of other online file hash generators you can use, such as this one: https://toolkitbay.com/tkb/tool/BLAKE2s_256


# About me

<h3  align="center"> I'm Gabriel Castro and I love coding softwares!</h3>

<sub  align="center">I'm a Lifelong learner, software developer, I study economy, blockchains, tech, astronomy and history. Intelectually generalist, I have interests in many fields of science. </sub>
  
###### Follow me on twitter:

<p  align="left">  <a  href="https://twitter.com/c4str0"  target="blank"><img  src="https://img.shields.io/twitter/follow/c4str0?logo=twitter&style=for-the-badge"  alt="c4str0"/></a>  </p>

<h3  align="left">Connect with me:</h3>

<p  align="left">

<a  href="https://twitter.com/c4str0"  target="blank"><img  align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/twitter.svg"  alt="c4str0"  height="30"  width="40"/></a>

</p>

<h3  align="left">Languages and Tools:</h3>

  

<p  align="left"><a  href="https://reactjs.org/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/react/react-original-wordmark.svg"  alt="react"  width="40"  height="40"/>  </a><a  href="https://nodejs.org"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/nodejs/nodejs-original-wordmark.svg"  alt="nodejs"  width="40"  height="40"/>  </a>  <a  href="https://www.postgresql.org"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/postgresql/postgresql-original-wordmark.svg"  alt="postgresql"  width="40"  height="40"/>  </a><a  href="https://developer.mozilla.org/en-US/docs/Web/JavaScript"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/javascript/javascript-original.svg"  alt="javascript"  width="40"  height="40"/>  </a>  <a  href="https://jestjs.io"  target="_blank"  rel="noreferrer">  <img  src="https://www.vectorlogo.zone/logos/jestjsio/jestjsio-icon.svg"  alt="jest"  width="40"  height="40"/>  </a><a  href="https://expressjs.com"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/express/express-original-wordmark.svg"  alt="express"  width="40"  height="40"/>  </a><a  href="https://www.docker.com/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg"  alt="docker"  width="40"  height="40"/>  </a><a  href="https://www.cprogramming.com/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/c/c-original.svg"  alt="c"  width="40"  height="40"/>  </a>  <a  href="https://www.w3schools.com/cpp/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/cplusplus/cplusplus-original.svg"  alt="cplusplus"  width="40"  height="40"/>  </a>  <a  href="https://git-scm.com/"  target="_blank"  rel="noreferrer">  <img  src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg"  alt="git"  width="40"  height="40"/>  </a>  <a  href="https://graphql.org"  target="_blank"  rel="noreferrer">  <img  src="https://www.vectorlogo.zone/logos/graphql/graphql-icon.svg"  alt="graphql"  width="40"  height="40"/>  </a>  <a  href="https://www.w3.org/html/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/html5/html5-original-wordmark.svg"  alt="html5"  width="40"  height="40"/>  </a>  <a  href="https://www.java.com"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/java/java-original.svg"  alt="java"  width="40"  height="40"/>  </a>  <a  href="https://www.mongodb.com/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mongodb/mongodb-original-wordmark.svg"  alt="mongodb"  width="40"  height="40"/>  </a>  <a  href="https://www.mysql.com/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mysql/mysql-original-wordmark.svg"  alt="mysql"  width="40"  height="40"/>  </a>  <a  href="https://www.oracle.com/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/oracle/oracle-original.svg"  alt="oracle"  width="40"  height="40"/>  </a>  <a  href="https://tailwindcss.com/"  target="_blank"  rel="noreferrer">  <img  src="https://www.vectorlogo.zone/logos/tailwindcss/tailwindcss-icon.svg"  alt="tailwind"  width="40"  height="40"/>  </a>  <a  href="https://www.typescriptlang.org/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/typescript/typescript-original.svg"  alt="typescript"  width="40"  height="40"/>  </a>  </p>
