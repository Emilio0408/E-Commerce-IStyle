document.addEventListener("DOMContentLoaded", function() {
    // Animazione di ingresso
     const confirmationCard = document.querySelector('.confirmation-card');
    if (confirmationCard) {
        confirmationCard.style.opacity = '0';
        confirmationCard.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            confirmationCard.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            confirmationCard.style.opacity = '1';
            confirmationCard.style.transform = 'translateY(0)';
        }, 100);
    }
    
    // Calcolo iniziale
    recalcTotals();
});