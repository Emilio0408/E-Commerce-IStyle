// Inizializzazione tsParticles
tsParticles.load("tsparticles", {
    fpsLimit: 60,
    particles: {
        number: { value: 80, density: { enable: true, area: 800 } },
        color: { value: "#E75919" },
        shape: { type: "circle" },
        opacity: { value: 0.6, random: true },
        size: { value: { min: 2, max: 5 }, random: true },
        move: {
            enable: true,
            speed: 1.5,
            direction: "none",
            outModes: { default: "bounce" }
        },
        links: {
            enable: true,
            distance: 120,
            color: "#ffffff",
            opacity: 0.2,
            width: 1
        }
    },
    interactivity: {
        detectsOn: "canvas",
        events: {
            onHover: { enable: true, mode: "grab" },
            onClick: { enable: true, mode: "push" },
            resize: true
        },
        modes: {
            grab: { distance: 140, links: { opacity: 0.5 } },
            push: { quantity: 4 }
        }
    },
    detectRetina: true
});

document.addEventListener("DOMContentLoaded", function() {
    // Mostra/nascondi dettagli ordine
    window.toggleOrderDetails = function(orderId) {
        const details = document.getElementById(orderId);
        const btn = document.querySelector(`button[onclick="toggleOrderDetails('${orderId}')"]`);
        const icon = btn.querySelector('i');
        
        // Chiudi tutti gli altri dettagli
        document.querySelectorAll('.order-details').forEach(d => {
            if (d.id !== orderId) {
                d.classList.remove('active');
                const otherBtn = d.closest('.order-card').querySelector('.order-details-btn');
                otherBtn.classList.remove('active');
                otherBtn.querySelector('i').classList.remove('fa-chevron-up');
                otherBtn.querySelector('i').classList.add('fa-chevron-down');
            }
        });
        
        // Alterna lo stato corrente
        details.classList.toggle('active');
        btn.classList.toggle('active');
        
        // Cambia icona
        if (details.classList.contains('active')) {
            icon.classList.remove('fa-chevron-down');
            icon.classList.add('fa-chevron-up');
        } else {
            icon.classList.remove('fa-chevron-up');
            icon.classList.add('fa-chevron-down');
        }
    };
    
});