function showAlert(message, type) {
  const alert = document.getElementById('custom-alert');
  const alertMessage = document.getElementById('alert-message');
  const closeButton = document.getElementById('close-alert');

  // Imposta messaggio e colore


  alertMessage.textContent = message;
  alert.className = type === 'success' ? 'alert-success' : 'alert-error';

  // Mostra l'alert
  alert.classList.remove('alert-hidden');
  alert.classList.add('alert-visible');

  // Chiudi l'alert al click sul pulsante
  closeButton.onclick = () => {
    alert.classList.remove('alert-visible');
    alert.classList.add('alert-hidden');
  };

  // Chiudi automaticamente dopo 5 secondi (opzionale)
  setTimeout(() => {
    alert.classList.remove('alert-visible');
    alert.classList.add('alert-hidden');
  }, 5000);
}