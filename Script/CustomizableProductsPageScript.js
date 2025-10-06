document.addEventListener("DOMContentLoaded", function () {
    // Animazione al passaggio del mouse sulle card prodotto
    document.querySelectorAll('.card-prodotto').forEach(card => {
        card.addEventListener('mouseenter', () => {
            card.style.transform = 'translateY(-8px)';
            card.style.boxShadow = 'var(--shadow-hover)';
        });
        
        card.addEventListener('mouseleave', () => {
            card.style.transform = '';
            card.style.boxShadow = 'var(--shadow)';
        });
    });

    // Animazione pulsanti personalizza
    document.querySelectorAll('.btn-personalizza').forEach(btn => {
        btn.addEventListener('mouseenter', () => {
            btn.style.transform = 'translateY(-3px)';
            btn.querySelector('.personalizza-icon').style.transform = 'translateX(3px)';
        });
        
        btn.addEventListener('mouseleave', () => {
            btn.style.transform = '';
            btn.querySelector('.personalizza-icon').style.transform = '';
        });
    });
});



//Listener per richiesta ajax relativa allo scorrimento sui colori
document.addEventListener('DOMContentLoaded', addColorHoverListeners)
