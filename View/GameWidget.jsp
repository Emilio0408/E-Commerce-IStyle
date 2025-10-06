<%@ page language="java" pageEncoding="UTF-8" %>

<style>
    /* Widget posizionato sulla sinistra */
    .game-widget {
        position: fixed;
        left: 20px;
        top: 50%;
        transform: translateY(-50%);
        z-index: 1000;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .game-icon {
        width: 60px;
        height: 60px;
        background: linear-gradient(135deg, #f6904dff 0%, #ff4d00ff 100%);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        animation: pulse 2s infinite;
        border: 3px solid white;
    }

    .game-icon:hover {
        transform: scale(1.1);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
    }

    .game-icon svg {
        width: 30px;
        height: 30px;
        fill: white;
    }

    @keyframes pulse {
        0% {
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2), 0 0 0 0 rgba(102, 126, 234, 0.7);
        }
        70% {
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2), 0 0 0 10px rgba(102, 126, 234, 0);
        }
        100% {
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2), 0 0 0 0 rgba(102, 126, 234, 0);
        }
    }

    /* Tooltip */
    .game-tooltip {
        position: absolute;
        left: 80px;
        top: 50%;
        transform: translateY(-50%);
        background: #333;
        color: white;
        padding: 8px 12px;
        border-radius: 6px;
        white-space: nowrap;
        opacity: 0;
        visibility: hidden;
        transition: all 0.3s ease;
        font-size: 14px;
        font-family: Arial, sans-serif;
    }

    .game-tooltip::before {
        content: '';
        position: absolute;
        left: -5px;
        top: 50%;
        transform: translateY(-50%);
        width: 0;
        height: 0;
        border-top: 5px solid transparent;
        border-bottom: 5px solid transparent;
        border-right: 5px solid #333;
    }

    .game-widget:hover .game-tooltip {
        opacity: 1;
        visibility: visible;
    }

    /* Modal/Alert personalizzato */
    .game-modal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.7);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 10000;
        opacity: 0;
        visibility: hidden;
        transition: all 0.3s ease;
    }

    .game-modal.active {
        opacity: 1;
        visibility: visible;
    }

    .game-modal-content {
        background: white;
        padding: 30px;
        border-radius: 15px;
        max-width: 400px;
        width: 90%;
        text-align: center;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        transform: scale(0.7);
        transition: all 0.3s ease;
    }

    .game-modal.active .game-modal-content {
        transform: scale(1);
    }

    .game-modal-header {
        margin-bottom: 20px;
    }

    .game-modal-title {
        font-size: 24px;
        color: #333;
        margin-bottom: 10px;
        font-family: 'Arial', sans-serif;
        font-weight: bold;
    }

    .game-modal-subtitle {
        font-size: 16px;
        color: #666;
        margin-bottom: 20px;
        line-height: 1.4;
    }

    .game-modal-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
        margin-top: 25px;
    }

    .game-btn {
        padding: 12px 24px;
        border: none;
        border-radius: 6px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-block;
    }

    .game-btn-primary {
        background: linear-gradient(135deg,  #f6904dff 0%, #ff4d00ff 100%);
        color: white;
    }

    .game-btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }

    .game-btn-secondary {
        background: #f8f9fa;
        color: #333;
        border: 2px solid #e9ecef;
    }

    .game-btn-secondary:hover {
        background: #e9ecef;
    }

    .game-emoji {
        font-size: 48px;
        margin-bottom: 15px;
        display: block;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .game-widget {
            left: 10px;
        }
        
        .game-icon {
            width: 50px;
            height: 50px;
        }
        
        .game-icon svg {
            width: 25px;
            height: 25px;
        }
        
        .game-modal-content {
            padding: 20px;
        }
        
        .game-modal-buttons {
            flex-direction: column;
        }
    }
</style>

<div class="game-widget" onclick="showGameModal()">
    <div class="game-icon">
        <svg viewBox="0 0 24 24">
            <path d="M7,6H17A6,6 0 0,1 23,12A6,6 0 0,1 17,18C15.22,18 13.63,17.23 12.53,16H11.47C10.37,17.23 8.78,18 7,18A6,6 0 0,1 1,12A6,6 0 0,1 7,6M7,8A4,4 0 0,0 3,12A4,4 0 0,0 7,16C8.17,16 9.23,15.47 9.86,14.64L10.75,13.5H13.25L14.14,14.64C14.77,15.47 15.83,16 17,16A4,4 0 0,0 21,12A4,4 0 0,0 17,8H7M9,10A1,1 0 0,1 10,11A1,1 0 0,1 9,12A1,1 0 0,1 8,11A1,1 0 0,1 9,10M16,10A1,1 0 0,1 17,11A1,1 0 0,1 16,12A1,1 0 0,1 15,11A1,1 0 0,1 16,10Z"/>
        </svg>
    </div>
    <div class="game-tooltip">Gioca e vinci!</div>
</div>

<div class="game-modal" id="gameModal">
    <div class="game-modal-content">
        <div class="game-modal-header">
            <span class="game-emoji">🎮</span>
            <h2 class="game-modal-title">Gioca e Vinci!</h2>
            <p class="game-modal-subtitle">
                Prova il nostro gioco divertente e potresti vincere sconti esclusivi sulle nostre cover!
            </p>
        </div>
        <div class="game-modal-buttons">
            <a href="<%=request.getContextPath() + "/View/Gioco.jsp"%>" class="game-btn game-btn-primary">Gioca Ora!</a>
            <button class="game-btn game-btn-secondary" onclick="hideGameModal()">Forse dopo</button>
        </div>
    </div>
</div>

<script>
    function showGameModal() {
        const modal = document.getElementById('gameModal');
        modal.classList.add('active');
        
        document.body.style.overflow = 'hidden';
    }

    function hideGameModal() {
        const modal = document.getElementById('gameModal');
        modal.classList.remove('active');
        
        document.body.style.overflow = 'auto';
    }

    document.getElementById('gameModal').addEventListener('click', function(e) {
        if (e.target === this) {
            hideGameModal();
        }
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            hideGameModal();
        }
    });

</script>