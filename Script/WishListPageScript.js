src="https://cdn.jsdelivr.net/npm/tsparticles@2">
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




//Listener per associare la richiesta di rimozione del prodotto ad ogni bottone di rimozione
document.addEventListener('DOMContentLoaded', function()
{
    const removeButtons = document.querySelectorAll('.remove-item-btn');
    removeButtons.forEach(btn => {
        btn.addEventListener('click',function(e){
            e.stopPropagation();
            e.preventDefault();
            removeFromWishlist(btn);
        });
    })
})

//RICHIESTA AJAX per rimozione del prodotto dalla wishlist
async function removeFromWishlist(btn) {
    const contextPath = document.querySelector('body').dataset.contextPath;
    const productId = btn.dataset.productId;
    const wishListItem = btn.closest('.wishlist-item');
    const itemCount = document.querySelector('.wishlist-count');
    const wishListContainer = document.querySelector('.wishlist-items');

    try {
        const response = await fetch(`${contextPath}/user/wishlist?action=remove`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: `IDProduct=${productId}`
        });

        const result = await response.json();

        if (result.success) {
            wishListItem.remove();
            showAlert("Prodotto rimosso dai preferiti!", "success");
            itemCount.textContent = "Articoli: " + result.data;


            if(result.data == 0)
            {
                wishListContainer.innerHTML = `
                    <div class="empty-wishlist" id="empty-wishlist">
                        <div class="empty-wishlist-icon">
                            <i class="fas fa-heart-broken"></i>
                        </div>
                        <h3 class="empty-wishlist-message">La tua WishList è vuota</h3>
                        <a href="${contextPath}/product" class="continue-shopping">Continua lo shopping</a>
                    </div>
                `;
            }

        } else {
            showAlert(result.message || "Errore durante la rimozione", "error");
        }
    } catch (error) {
        showAlert("Errore di connessione", "error");
        console.error("Errore AJAX:", error);
    }
}