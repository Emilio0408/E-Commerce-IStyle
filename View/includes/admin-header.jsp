<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pannello Admin - iStyle</title>
  <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/AdminHeaderStyle.css"%>">
  <link rel="stylesheet" href="<%=request.getContextPath() + "/StyleSheet/includes/Style.css"%>">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
  <div class="admin-container">
    <div class="sidebar">
      <div class="logo-mobile">
        <h2><img src="<%=request.getContextPath() + "/images/icons/logoNuovo.png"%>" alt="Logo">iStyle Admin</h2>
      </div>
      <ul>
        <li><a href="admin-prodotti.jsp"><i class="fas fa-box-open"></i> Prodotti</a></li>
        <li><a href="admin-ordini.jsp"><i class="fas fa-shopping-bag"></i> Ordini</a></li>
        <li><a href="#logout"><i class="fas fa-sign-out-alt"></i> Esci</a></li>
      </ul>
    </div>

    <div class="main-content">