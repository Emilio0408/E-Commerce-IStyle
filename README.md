# IStyle E-Commerce

IStyle è un e-commerce di cover e prodotti per iPhone. Oltre ad avere tutte le funzionalità di base di un e-commerce, 
presenta anche un'interfaccia e delle funzionalità aggiuntive che rendono l'esperienza utente più comoda e semplice.

## 🛠 Tecnologie Utilizzate

- **JDK 21.0.4**
- **JSP / Servlet**
- **HTML5, CSS3, JavaScript**
- **MySQL** (Database)
- **Apache Tomcat 9** (Application Server per l'esecuzione del codice Java)

## 📁 Struttura del Progetto

<pre>
src/
├── it/IStyle/control/ # Servlet
├── it/IStyle/filters/ # Filtri per la sicurezza
├── it/IStyle/modelbean/ # Classi Java Bean
├── it/IStyle/modeldao/ # DAO per connessione e query al DB
└── it/IStyle/utils/ # Classi Java utili per l'implementazione

Stylesheet/ # File CSS per lo stile
Script/ # File JavaScript (AJAX e front-end)
View/ # File JSP per la struttura delle pagine
WEB-INF/web.xml # Deployment Descriptor

</pre>



## ⚙️ Installazione e Avvio

### Prerequisiti

- [JDK 21.0.4](https://download.oracle.com/java/21/archive/jdk-21.0.4_windows-x64_bin.exe)
- [Apache Tomcat 9](https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.110/bin/apache-tomcat-9.0.110.exe)
- [MySQL Workbench](https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.43-winx64.msi)

### Configurazione del Database

1. Apri MySQL Workbench e verifica che il server MySQL sia in ascolto sulla porta 3306
2. Esegui il comando: `netstat -an | findstr 3306` per verificare la porta
3. Esegui lo script SQL `DumpIStyleDB.sql` per creare il database con dati di esempio

### Avvio della Web App

1. Crea una cartella chiamata "IStyle" sotto "webapps" di Tomcat
2. Copia tutte le cartelle e i file del progetto nella cartella "IStyle"
3. Avvia Tomcat
4. Apri il browser e accedi a: `http://localhost:8080/IStyle`

## ⚠️ Nota Importante

La funzionalità di checkout potrebbe non funzionare in quanto le chiavi Stripe per la simulazione dei pagamenti non sono incluse per motivi di privacy.

Per abilitare i pagamenti:
1. Crea un account Stripe
2. Copia la chiave di prova dal tuo account
3. Inserisci la key in:
   - `CheckoutControl.java` (riga 60) - `Stripe.apiKey=""`
   - `ConfirmOrderControl.java` (riga 58) - `Stripe.apiKey=""`

## 🚀 Funzionalità Principali

- ✅ Registrazione e login utente
- ✅ Carrello prodotti
- ✅ Gestione ordini
- ✅ Pannello admin
- ✅ Sezione utente
- ✅ Lista dei desideri
- ✅ Checkout

## 👥 Autori

Sviluppato da:
- Emilio Maione
- Gianluca Del Gaizo
- Gabriele Milone
- Mario De Simone
