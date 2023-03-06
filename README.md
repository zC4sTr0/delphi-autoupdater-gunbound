<p  align="center"><img  src="preview/preview-mainform.png"  alt="PREVIEW"  width="100"  height="100"></p>
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
  <div align="center"><sub>Made with ❤︎ by <a href="https://github.com/zC4sTr0">Gabriel Castro</a></sub></div>
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
The PascalUpdater also supports compressed ZIP files with passwords, which can be particularly useful in avoiding antivirus software issues during the download process. The extraction process is fast, but users may be able to achieve even better results by changing the compression algorithm.<br>
The Updater also extract the ZIP sucessfully (all with progress bars!)

## File Hash Check
To ensure that only the necessary files are updated, the PascalUpdater uses a file called "filelist.dat" which contains the names, sizes, and Blake-256 hashes of all the files required for the update. The updater compares the hashes of the files in the client folder with those in the filelist.dat file to ensure that the files are up-to-date and unmodified. This feature ensures that the update process is not only efficient but also secure.

## Blake Hash Algorithm

In order to ensure that files are up-to-date, the PascalUpdater uses the fast and accurate Blake-256 algorithm to calculate hashes. <br>
The Blake-256 hash algorithm is a cryptographic hash function that produces a 256-bit hash value. It was created by Jean-Philippe Aumasson, Samuel Neves, Zooko Wilcox-O'Hearn, and Christian Winnerlein. The algorithm is named after one of the creators, Jean-Philippe Aumasson's, newborn son Blake.

The Blake-256 algorithm is known for its speed and security. It has been extensively analyzed and tested, and is widely regarded as a secure and reliable hash function. The algorithm uses a combination of cryptographic techniques, including keying, message padding, and data compression, to produce its hash values.

In the context of the Updater, the Blake-256 hash algorithm is used to ensure the integrity and authenticity of the downloaded files. When a file is downloaded, the PascalUpdater calculates the hash value of the file using the Blake-256 algorithm. The calculated hash value is then compared to the expected hash value stored in the filelist.dat file. If the calculated hash value matches the expected hash value, the file is deemed to be authentic and can be installed. If the hash values do not match, the file is considered to be corrupt or tampered with, and the updater will not install it.

Overall, the Blake-256 hash algorithm is an excellent choice for ensuring the security and integrity of downloaded files. Its speed and reliability make it a popular choice in a variety of applications, including the PascalUpdater used in GunBound GitzWC.

In summary, the PascalUpdater with Blake hash algorithm is a powerful tool for updating files efficiently and quickly. Its support for threads and compressed ZIP files with passwords make it an excellent choice for anyone who wants to avoid issues that may arise during the download process, such as antivirus software problems.

## Background Image Support
The PascalUpdater supports a custom background image for the updater interface. If the image file exists in the same folder as the updater executable, it will be loaded and displayed as the background. This feature adds a nice touch of customization to the updater.

## Task Killing
The updater is able to kill specific processes before updating, which helps to ensure that there are no conflicts or issues with running programs. The following processes are targeted: "GitzGame.exe," "NyxLauncher.exe," "UpdaterReplacer.exe," and "GbSet.exe." Killing these processes helps to ensure a smooth update process.

## Multi-Language Support
The updater have support in English, Portugues and Spanish languages and it's very easy to add more languages.

## File Deletion
The updater also has the ability to delete files before updating, which can be useful in ensuring that old files are not left behind. The following files are deleted: ".tmp," ".bak," "*.gp," "replacelist.dat," and "filelist.dat."

## Updater.ini Creation
If the updater.ini file does not exist in the same folder as the updater executable, the updater will create it and save it. This file is used to configure the updater settings, such as the FTP host, user credentials, and update files.

# How to run

To run this applications, you must have Delphi 7+ installed in your computer.

Read more about how to Install Delphi here: https://www.embarcadero.com/br/products/delphi/starter/free-download

# About me

<h3  align="center"> I'm Gabriel Castro and I love coding softwares!</h3>

<sub  align="center">I'm a Lifelong learner, software developer, I study economy, blockchains, tech, astronomy and history. Intelectually generalist, I have interests in many fields of science. </sub>
  
###### I talk about Bitcoin, web3, and economy on my twitter:

<p  align="left">  <a  href="https://twitter.com/c4str0"  target="blank"><img  src="https://img.shields.io/twitter/follow/c4str0?logo=twitter&style=for-the-badge"  alt="c4str0"/></a>  </p>

<sub> My twitter is worth to check since it has 2 years of recorded proofs of my true love about economy, bitcoin and my own travel through the bitcoin's rabbit hole.</sub>

- 🔭 I’m currently working on [GunBound GITZ](www.gitzwc.com) as Founder/CEO

- 🌱 I’m currently studying **Solidity, Python and React Native**

- 👨‍💻 All of my projects are available at [www.github.com/zC4sTr0](www.github.com/zC4sTr0)

- 📫 How to reach me: **gabriel.sodre@aluno.ufop.edu.br**

<h3  align="left">Connect with me:</h3>

<p  align="left">

<a  href="https://twitter.com/c4str0"  target="blank"><img  align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/twitter.svg"  alt="c4str0"  height="30"  width="40"/></a><a  href="https://www.linkedin.com/in/gabriel-castro-sodre/"  target="blank"><img  align="center"  src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg"  alt="https://www.linkedin.com/in/gabriel-castro-sodre/"  height="30"  width="40"  /></a>

</p>

<h3  align="left">Languages and Tools:</h3>

  

<p  align="left"><a  href="https://reactjs.org/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/react/react-original-wordmark.svg"  alt="react"  width="40"  height="40"/>  </a><a  href="https://nodejs.org"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/nodejs/nodejs-original-wordmark.svg"  alt="nodejs"  width="40"  height="40"/>  </a>  <a  href="https://www.postgresql.org"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/postgresql/postgresql-original-wordmark.svg"  alt="postgresql"  width="40"  height="40"/>  </a><a  href="https://developer.mozilla.org/en-US/docs/Web/JavaScript"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/javascript/javascript-original.svg"  alt="javascript"  width="40"  height="40"/>  </a>  <a  href="https://jestjs.io"  target="_blank"  rel="noreferrer">  <img  src="https://www.vectorlogo.zone/logos/jestjsio/jestjsio-icon.svg"  alt="jest"  width="40"  height="40"/>  </a><a  href="https://expressjs.com"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/express/express-original-wordmark.svg"  alt="express"  width="40"  height="40"/>  </a><a  href="https://www.docker.com/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg"  alt="docker"  width="40"  height="40"/>  </a><a  href="https://www.cprogramming.com/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/c/c-original.svg"  alt="c"  width="40"  height="40"/>  </a>  <a  href="https://www.w3schools.com/cpp/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/cplusplus/cplusplus-original.svg"  alt="cplusplus"  width="40"  height="40"/>  </a>  <a  href="https://git-scm.com/"  target="_blank"  rel="noreferrer">  <img  src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg"  alt="git"  width="40"  height="40"/>  </a>  <a  href="https://graphql.org"  target="_blank"  rel="noreferrer">  <img  src="https://www.vectorlogo.zone/logos/graphql/graphql-icon.svg"  alt="graphql"  width="40"  height="40"/>  </a>  <a  href="https://www.w3.org/html/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/html5/html5-original-wordmark.svg"  alt="html5"  width="40"  height="40"/>  </a>  <a  href="https://www.java.com"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/java/java-original.svg"  alt="java"  width="40"  height="40"/>  </a>  <a  href="https://www.mongodb.com/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mongodb/mongodb-original-wordmark.svg"  alt="mongodb"  width="40"  height="40"/>  </a>  <a  href="https://www.mysql.com/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mysql/mysql-original-wordmark.svg"  alt="mysql"  width="40"  height="40"/>  </a>  <a  href="https://www.oracle.com/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/oracle/oracle-original.svg"  alt="oracle"  width="40"  height="40"/>  </a>  <a  href="https://tailwindcss.com/"  target="_blank"  rel="noreferrer">  <img  src="https://www.vectorlogo.zone/logos/tailwindcss/tailwindcss-icon.svg"  alt="tailwind"  width="40"  height="40"/>  </a>  <a  href="https://www.typescriptlang.org/"  target="_blank"  rel="noreferrer">  <img  src="https://raw.githubusercontent.com/devicons/devicon/master/icons/typescript/typescript-original.svg"  alt="typescript"  width="40"  height="40"/>  </a>  </p>