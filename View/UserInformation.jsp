<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.LinkedList , it.IStyle.model.bean.ProductBean, it.IStyle.model.bean.Feedback, it.IStyle.model.bean.User, it.IStyle.model.bean.Address, it.IStyle.utils.Utils, java.util.Map , java.util.HashMap, java.util.HashSet" %>



<!DOCTYPE html>

<%  
    User user = (User) request.getAttribute("UserInformation");
    String Name = user.getName();
    String Surname = user.getSurname();
    String email = user.getEmail();
    LinkedList<Address> addressesOfUser = user.getAddresses();


%>


<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Profilo - IStyle</title>
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Alert.css"%>">
    <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/UserInformationStyle.css"%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body data-context-path ="<%=request.getContextPath()%>"> 

<%@ include file="includes/Alert.jsp" %>
<%@ include file="includes/Header.jsp" %>

<div class="profile-container">
    <h1 class="section__headline">Gestione Profilo</h1>
    <p class="profile-subtitle">Modifica i tuoi dati personali e gestisci i tuoi indirizzi</p>

    <div class="profile-grid">
        <!-- Sezione Informazioni Personali -->
        <div class="profile-card">
            <div class="profile-header">
                <i class="fas fa-user-circle profile-icon"></i>
                <h2>Informazioni Personali</h2>
            </div>
            
            <div class="profile-info">
                <div class="info-row">
                    <span class="info-label">Nome:</span>
                    <span class="info-value" id="nome-value"><%=Name%></span>
                    <button class="edit-btn" onclick="openEditForm('nome')"><i class="fas fa-pencil-alt"></i></button>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Cognome:</span>
                    <span class="info-value" id="cognome-value"><%=Surname%></span>
                    <button class="edit-btn" onclick="openEditForm('cognome')"><i class="fas fa-pencil-alt"></i></button>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Email:</span>
                    <span class="info-value" id="email-value"><%=email%></span>
                    <button class="edit-btn" onclick="openEditForm('email')"><i class="fas fa-pencil-alt"></i></button>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Password:</span>
                    <span class="info-value">••••••••</span>
                    <button class="edit-btn" onclick="openEditForm('password')"><i class="fas fa-pencil-alt"></i></button>
                </div>
            </div>
        </div>

        <!-- Sezione Indirizzi -->
        <div class="profile-card">
            <div class="profile-header">
                <i class="fas fa-map-marker-alt profile-icon"></i>
                <h2>I Tuoi Indirizzi</h2>
                <button class="add-address-btn" onclick="openAddAddressModal()">
                    <i class="fas fa-plus"></i> Aggiungi Indirizzo
                </button>
            </div>
            
            <div class="addresses-container">  <!--Aggiungi gli indirizzi dell'utente in questo container-->

                <%
                    if(addressesOfUser != null && addressesOfUser.size() > 0)
                    {
                        for(Address a : addressesOfUser)
                        {
                %>

                    <!-- Indirizzo Casa -->
                    <div class="address-section" id="casa" data-id-address="<%=a.getIDIndirizzo()%>">
                        <div class="address-header">
                            <h3><i class="fas fa-home"></i> Indirizzo <%=a.getTipologia()%></h3>
                            <button class="delete-address-btn">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                        <div class="address-info">
                            <p><span class="info-label">Via:</span> <span><%=a.getVia() + ", " + a.getNumeroCivico()%></span></p>
                            <p><span class="info-label">Città:</span> <span><%=a.getCitta()%></span></p>
                            <p><span class="info-label">CAP:</span> <span><%=a.getCAP()%></span></p>
                            <p><span class="info-label">Nazione:</span> <span><%=a.getNazione()%></span></p>
                        </div>
                    </div>

                <%
                        }
                    }
                    else
                    {
                %>
                        <p style="text-align:center"> Non ci sono indirizzi salvati, clicca il pulsante "aggiungi indirizzo" per inserirne uno nuovo </p>

                <%
                    }
                %>
            </div>
        </div>
</div>
</div>

<!-- Modale per modifica campo -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="modal-title">Modifica Nome</h3>
            <button class="close-btn" onclick="closeEditForm()">&times;</button>
        </div>
        <div class="modal-body">
            <form id="editForm"> <!--Associare la richiesta ajax per la modifica del campo selezionato-->
                <div class="form-group">
                    <label id="field-label" for="edit-field"></label>
                    <input type="text" id="edit-field" class="form-input" required>
                    <div id="password-requirements" style="display: none;">
                        <p>La password deve contenere:</p>
                        <ul>
                            <li>Almeno 8 caratteri</li>
                            <li>Almeno una lettera maiuscola</li>
                            <li>Almeno un numero</li>
                            <li>Almeno un carattere speciale</li>
                        </ul>
                    </div>
                </div>
                <div class="form-group">
                    <label id="confirm-label" for="confirm-field" style="display: none;">Conferma password:</label>
                    <input type="password" id="confirm-field" class="form-input" style="display: none;">
                </div>
                <div class="form-actions">
                    <button type="button" class="btn cancel-btn" onclick="closeEditForm()">Annulla</button>
                    <button type="submit" class="btn save-btn">Salva</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modale per aggiungere indirizzo -->
<div id="addAddressModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Aggiungi Nuovo Indirizzo</h3>
            <button class="close-btn" onclick="closeAddAddressModal()">&times;</button>
        </div>
        <div class="modal-body">
            <form id="addAddressForm">
                <div class="form-group">
                    <label for="address-type">Tipo Indirizzo:</label>
                    <select id="address-type" class="form-input" required>
                        <option value="">Seleziona...</option>
                        <option value="spedizione">Casa</option>
                        <option value="fatturazione">Fatturazione</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="address-via">Via:</label>
                    <input type="text" id="address-via" class="form-input" required>
                </div>

                <div class="form-group">
                    <label for="address-ncivico">Numero civico:</label>
                    <input type="text" id="address-n-civico" class="form-input" required>
                </div>
                
                <div class="form-group">
                    <label for="address-citta">Città:</label>
                    <input type="text" id="address-citta" class="form-input" required>
                </div>
                
                <div class="form-group">
                    <label for="address-cap">CAP:</label>
                    <input type="text" id="address-cap" class="form-input" required>
                </div>
                
                <div class="form-group">
                    <label for="address-nazione">Nazione:</label>
                    <input type="text" id="address-nazione" class="form-input" required>
                </div>
            </form>
        </div>


        <div class="form-actions">
            <button type="button" class="btn cancel-btn" onclick="closeAddAddressModal()">Annulla</button>
            <button type="submit" form="addAddressForm" class="btn save-btn">Salva Indirizzo</button>
        </div>


    </div>
</div>



<%@ include file="includes/Footer.jsp" %>



<script src="<%=request.getContextPath() + "/Script/includes/Alert.js"%>"></script>
<script src="<%=request.getContextPath() + "/Script/UserInformationScript.js"%>"></script>

</body>
</html>