<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Snake Runner - Vinci Sconti Esclusivi!</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Orbitron', monospace;
            background: linear-gradient(135deg, #ffeaa7 0%, #74b9ff 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            color: white;
            overflow-x: hidden;
        }

        .header {
            text-align: center;
            padding: 20px;
            background: rgba(0,0,0,0.3);
            width: 100%;
            backdrop-filter: blur(10px);
            border-bottom: 2px solid rgba(255,255,255,0.1);
        }

        .header h1 {
            font-size: 2.5em;
            font-weight: 900;
            text-shadow: 0 0 20px rgba(255,255,255,0.5);
            margin-bottom: 10px;
            background: linear-gradient(45deg, #ffd700, #ffed4e);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .subtitle {
            font-size: 1.2em;
            opacity: 0.9;
            margin-bottom: 10px;
        }

        .discount-info {
            background: rgba(255,215,0,0.2);
            padding: 10px 20px;
            border-radius: 25px;
            border: 2px solid #ffd700;
            margin-top: 10px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .game-container {
            position: relative;
            margin: 30px auto;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            border: 3px solid rgba(255,255,255,0.2);
        }

        #gameCanvas {
            display: block;
            background: linear-gradient(45deg, #2d3436 25%, #636e72 25%, #636e72 50%, #2d3436 50%, #2d3436 75%, #636e72 75%);
            background-size: 20px 20px;
        }

        .controls {
            text-align: center;
            margin: 20px;
            background: rgba(0,0,0,0.3);
            padding: 20px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }

        .controls h3 {
            margin-bottom: 15px;
            color: #ffd700;
        }

        .control-item {
            margin: 10px 0;
            padding: 8px 15px;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            display: inline-block;
            margin-right: 10px;
        }

        .stats {
            display: flex;
            justify-content: space-around;
            margin: 20px;
            background: rgba(0,0,0,0.3);
            padding: 15px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            font-size: 1.5em;
            font-weight: bold;
            color: #ffd700;
        }

        .discount-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-content {
            background: linear-gradient(135deg, #ffeaa7 0%, #74b9ff 100%);
            padding: 30px;
            border-radius: 20px;
            text-align: center;
            max-width: 400px;
            border: 3px solid #ffd700;
            animation: modalAppear 0.5s ease-out;
        }

        @keyframes modalAppear {
            from { transform: scale(0.5); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        .discount-code {
            font-size: 2em;
            color: #ffd700;
            font-weight: bold;
            margin: 20px 0;
            padding: 15px;
            background: rgba(0,0,0,0.3);
            border-radius: 10px;
            border: 2px dashed #ffd700;
        }

        .btn {
            background: linear-gradient(45deg, #ffd700, #ffed4e);
            color: #333;
            border: none;
            padding: 12px 25px;
            border-radius: 25px;
            cursor: pointer;
            font-family: 'Orbitron', monospace;
            font-weight: bold;
            font-size: 1em;
            transition: all 0.3s ease;
            margin: 10px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255,215,0,0.4);
        }

        .start-screen {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            z-index: 100;
        }

        .start-screen h2 {
            font-size: 2.5em;
            margin-bottom: 20px;
            color: #ffd700;
        }

        .start-screen .instructions {
            text-align: center;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .game-over {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(0,0,0,0.8);
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            display: none;
            border: 2px solid #ff4757;
            z-index: 100;
        }

        .pause-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            display: none;
            align-items: center;
            justify-content: center;
            font-size: 3em;
            color: white;
            font-weight: bold;
            z-index: 100;
        }

        @media (max-width: 768px) {
            .header h1 { font-size: 2em; }
            .subtitle { font-size: 1em; }
            #gameCanvas { width: 100%; max-width: 400px; }
            .stats { flex-direction: column; gap: 10px; }
            .start-screen h2 { font-size: 2em; }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🐍 SNAKE RUNNER</h1>
        <p class="subtitle">Mangia i Telefoni, Vinci Sconti Esclusivi!</p>
        <div class="discount-info">
            ⭐ Raggiungi 50 punti per uno sconto del 10%<br>
            🎯 Raggiungi 100 punti per uno sconto del 20%<br>
            🔥 Raggiungi 200 punti per uno sconto del 30%
        </div>
    </div>

    <div class="game-container">
        <canvas id="gameCanvas" width="600" height="400"></canvas>
        
        <div class="start-screen" id="startScreen">
            <h2>🐍 SNAKE RUNNER</h2>
            <div class="instructions">
                <p>Usa le frecce per muoverti!</p>
                <p>Mangia i telefoni per crescere e aumentare il punteggio!</p>
                <p>Evita di colpire i muri e te stesso!</p>
                <p>Raggiungi i milestone per ottenere codici sconto!</p>
            </div>
            <button class="btn" onclick="startGame()">🚀 Inizia Partita</button>
        </div>
        
        <div class="pause-overlay" id="pauseOverlay">⏸️ PAUSA</div>
        
        <div class="game-over" id="gameOver">
            <h2>🎮 GAME OVER</h2>
            <p>Punteggio Finale: <span id="finalScore">0</span></p>
            <p>Lunghezza Snake: <span id="finalLength">3</span></p>
            <button class="btn" onclick="restartGame()">🔄 Riprova</button>
            <button class="btn" onclick="backToStart()">🏠 Menu Principale</button>
        </div>
    </div>

    <div class="controls">
        <h3>🎮 Comandi</h3>
        <div class="control-item">↑↓←→ - Movimento</div>
        <div class="control-item">P - Pausa</div>
        <div class="control-item">R - Riavvia</div>
    </div>

    <div class="stats">
        <div class="stat-item">
            <div class="stat-value" id="currentScore">0</div>
            <div>Punteggio</div>
        </div>
        <div class="stat-item">
            <div class="stat-value" id="bestScore">0</div>
            <div>Record</div>
        </div>
        <div class="stat-item">
            <div class="stat-value" id="snakeLength">3</div>
            <div>Lunghezza</div>
        </div>
    </div>

    <div class="discount-modal" id="discountModal">
        <div class="modal-content">
            <h2>🎉 CONGRATULAZIONI!</h2>
            <p>Hai guadagnato uno sconto!</p>
            <div class="discount-code" id="discountCode">SNAKE20</div>
            <p>Usa questo codice nel tuo prossimo acquisto!</p>
            <button class="btn" onclick="copyDiscountCode(this)">📋 Copia Codice</button>
            <button class="btn" onclick="closeDiscountModal()">✨ Continua a Giocare</button>
        </div>
    </div>

    <script>

        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');

        // Game constants
        const GRID_SIZE = 20;
        const GRID_WIDTH = canvas.width / GRID_SIZE;
        const GRID_HEIGHT = canvas.height / GRID_SIZE;

        // Game state
        let gameState = {
            score: 0,
            bestScore: 0,
            paused: false,
            gameOver: false,
            gameStarted: false,
            codesUsed: []
        };

        // Snake
        let snake = {
            body: [
                { x: 10, y: 10 },
                { x: 9, y: 10 },
                { x: 8, y: 10 }
            ],
            direction: { x: 1, y: 0 },
            nextDirection: { x: 1, y: 0 }
        };

        // Food (phone)
        let food = {
            x: 15,
            y: 15
        };

        // Initialize game
        function initGame() {
            // Load saved data
            gameState.bestScore = parseInt(localStorage.getItem('snakeRunnerBest') || '0');
            
            // Update UI
            document.getElementById('bestScore').textContent = gameState.bestScore;
            document.getElementById('currentScore').textContent = gameState.score;
            document.getElementById('snakeLength').textContent = snake.body.length;
            
            // Generate first food
            generateFood();
        }

        // Start game function
        function startGame() {
            gameState.gameStarted = true;
            gameState.gameOver = false;
            gameState.paused = false;
            document.getElementById('startScreen').style.display = 'none';
            gameLoop();
        }

        // Back to start screen
        function backToStart() {
            gameState.gameStarted = false;
            gameState.gameOver = false;
            gameState.paused = false;
            document.getElementById('startScreen').style.display = 'flex';
            document.getElementById('gameOver').style.display = 'none';
            document.getElementById('pauseOverlay').style.display = 'none';
            
            // Reset game state
            resetGameState();
        }

        

        // Reset game state
        function resetGameState() {
            gameState.score = 0;
            
            // Reset snake
            snake.body = [
                { x: 10, y: 10 },
                { x: 9, y: 10 },
                { x: 8, y: 10 }
            ];
            snake.direction = { x: 1, y: 0 };
            snake.nextDirection = { x: 1, y: 0 };
            
            // Generate new food
            generateFood();
            
            // Update UI
            document.getElementById('currentScore').textContent = gameState.score;
            document.getElementById('snakeLength').textContent = snake.body.length;
        }

        // Generate food at random position
        function generateFood() {
            do {
                food.x = Math.floor(Math.random() * GRID_WIDTH);
                food.y = Math.floor(Math.random() * GRID_HEIGHT);
            } while (isSnakePosition(food.x, food.y));
        }

        // Check if position is occupied by snake
        function isSnakePosition(x, y) {
            return snake.body.some(segment => segment.x === x && segment.y === y);
        }

        // Input handling
        document.addEventListener('keydown', (e) => {
            if (!gameState.gameStarted || gameState.gameOver) return;

            switch (e.key) {
                case 'ArrowUp':
                    if (snake.direction.y === 0) {
                        snake.nextDirection = { x: 0, y: -1 };
                    }
                    break;
                case 'ArrowDown':
                    if (snake.direction.y === 0) {
                        snake.nextDirection = { x: 0, y: 1 };
                    }
                    break;
                case 'ArrowLeft':
                    if (snake.direction.x === 0) {
                        snake.nextDirection = { x: -1, y: 0 };
                    }
                    break;
                case 'ArrowRight':
                    if (snake.direction.x === 0) {
                        snake.nextDirection = { x: 1, y: 0 };
                    }
                    break;
                case 'p':
                case 'P':
                    togglePause();
                    break;
                case 'r':
                case 'R':
                    restartGame();
                    break;
            }
        });

        // Touch controls for mobile
        let touchStartX = 0;
        let touchStartY = 0;

        canvas.addEventListener('touchstart', (e) => {
            e.preventDefault();
            if (!gameState.gameStarted) {
                startGame();
                return;
            }
            
            const touch = e.touches[0];
            touchStartX = touch.clientX;
            touchStartY = touch.clientY;
        });

        canvas.addEventListener('touchend', (e) => {
            e.preventDefault();
            if (!gameState.gameStarted || gameState.gameOver) return;
            
            const touch = e.changedTouches[0];
            const deltaX = touch.clientX - touchStartX;
            const deltaY = touch.clientY - touchStartY;
            
            if (Math.abs(deltaX) > Math.abs(deltaY)) {
                // Horizontal swipe
                if (deltaX > 0 && snake.direction.x === 0) {
                    snake.nextDirection = { x: 1, y: 0 };
                } else if (deltaX < 0 && snake.direction.x === 0) {
                    snake.nextDirection = { x: -1, y: 0 };
                }
            } else {
                // Vertical swipe
                if (deltaY > 0 && snake.direction.y === 0) {
                    snake.nextDirection = { x: 0, y: 1 };
                } else if (deltaY < 0 && snake.direction.y === 0) {
                    snake.nextDirection = { x: 0, y: -1 };
                }
            }
        });

        function togglePause() {
            if (gameState.gameOver || !gameState.gameStarted) return;
            gameState.paused = !gameState.paused;
            document.getElementById('pauseOverlay').style.display = gameState.paused ? 'flex' : 'none';
            if (!gameState.paused) {
                gameLoop();
            }
        }

        function update() {
            if (gameState.paused || gameState.gameOver) return;

            // Update direction
            snake.direction = { ...snake.nextDirection };

            // Move snake
            const head = { ...snake.body[0] };
            head.x += snake.direction.x;
            head.y += snake.direction.y;

            // Check wall collision
            if (head.x < 0 || head.x >= GRID_WIDTH || head.y < 0 || head.y >= GRID_HEIGHT) {
                endGame();
                return;
            }

            // Check self collision
            if (isSnakePosition(head.x, head.y)) {
                endGame();
                return;
            }

            // Add new head
            snake.body.unshift(head);

            // Check food collision
            if (head.x === food.x && head.y === food.y) {
                gameState.score += 10;
                generateFood();
                checkDiscountReward();
            } else {
                // Remove tail if no food eaten
                snake.body.pop();
            }

            // Update UI
            document.getElementById('currentScore').textContent = gameState.score;
            document.getElementById('snakeLength').textContent = snake.body.length;
        }

        function draw() {
            // Clear canvas
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // Draw grid background
            ctx.fillStyle = '#2d3436';
            for (let x = 0; x < GRID_WIDTH; x++) {
                for (let y = 0; y < GRID_HEIGHT; y++) {
                    if ((x + y) % 2 === 0) {
                        ctx.fillRect(x * GRID_SIZE, y * GRID_SIZE, GRID_SIZE, GRID_SIZE);
                    }
                }
            }

            // Draw snake
            snake.body.forEach((segment, index) => {
                if (index === 0) {
                    // Draw head
                    ctx.fillStyle = '#00b894';
                    ctx.fillRect(segment.x * GRID_SIZE, segment.y * GRID_SIZE, GRID_SIZE, GRID_SIZE);
                    
                    // Draw eyes
                    ctx.fillStyle = '#fff';
                    ctx.fillRect(segment.x * GRID_SIZE + 5, segment.y * GRID_SIZE + 5, 3, 3);
                    ctx.fillRect(segment.x * GRID_SIZE + 12, segment.y * GRID_SIZE + 5, 3, 3);
                } else {
                    // Draw body
                    ctx.fillStyle = index % 2 === 0 ? '#55a3ff' : '#74b9ff';
                    ctx.fillRect(segment.x * GRID_SIZE, segment.y * GRID_SIZE, GRID_SIZE, GRID_SIZE);
                }
                
                // Draw border
                ctx.strokeStyle = '#2d3436';
                ctx.lineWidth = 1;
                ctx.strokeRect(segment.x * GRID_SIZE, segment.y * GRID_SIZE, GRID_SIZE, GRID_SIZE);
            });

            // Draw food (phone)
            const phoneX = food.x * GRID_SIZE;
            const phoneY = food.y * GRID_SIZE;
            
            // Phone body
            ctx.fillStyle = '#2d3436';
            ctx.fillRect(phoneX + 2, phoneY + 2, GRID_SIZE - 4, GRID_SIZE - 4);
            
            // Phone screen
            ctx.fillStyle = '#74b9ff';
            ctx.fillRect(phoneX + 4, phoneY + 4, GRID_SIZE - 8, GRID_SIZE - 8);
            
            // Phone highlights
            ctx.fillStyle = '#fff';
            ctx.fillRect(phoneX + 5, phoneY + 5, GRID_SIZE - 10, 2);
            ctx.fillRect(phoneX + 8, phoneY + GRID_SIZE - 5, 4, 1);

            // Draw score
            if (gameState.gameStarted) {
                ctx.fillStyle = '#ffd700';
                ctx.font = 'bold 20px Orbitron';
                ctx.textAlign = 'right';
                ctx.fillText(`Score: ${gameState.score}`, canvas.width - 10, 25);
                ctx.fillText(`Best: ${gameState.bestScore}`, canvas.width - 10, 50);
                
                ctx.textAlign = 'left';
                ctx.fillText(`Length: ${snake.body.length}`, 10, 25);
            }
        }

        function checkDiscountReward() {
            const milestones = [
                { score: 50, discount: 10 },
                { score: 100, discount: 20 },
                { score: 200, discount: 30 }
            ];
            

            for (const milestone of milestones) {
                if (gameState.score >= milestone.score && !gameState.codesUsed.includes(milestone.discount)) {
                    showDiscountModal(milestone.discount);
                    gameState.codesUsed.push(milestone.discount);
                    break;
}

            }
        }

        function showDiscountModal(discount) {
            gameState.paused = true;
            const code = `PROF : ${discount}${"VOTO30&LODE"}`; //Math.floor(Math.random() * 1000)
            document.getElementById('discountCode').textContent = code;
            document.getElementById('discountModal').style.display = 'flex';
        }
        
        function closeDiscountModal() {
            document.getElementById('discountModal').style.display = 'none';
            gameState.paused = false;
            gameLoop();
        }

        function copyDiscountCode(button) {
            const code = document.getElementById('discountCode').textContent;
            navigator.clipboard.writeText(code).then(() => {
                const originalText = button.innerHTML;
                button.innerHTML = '✅ Copiato!';
                setTimeout(() => {
                    button.innerHTML = originalText;
                }, 2000);
            }).catch(err => {
                console.error('Could not copy text: ', err);
                alert('Impossibile copiare il codice.');
            });
        }

        function endGame() {
            if (gameState.gameOver) return;
            gameState.gameOver = true;

            if (gameState.score > gameState.bestScore) {
                gameState.bestScore = gameState.score;
                document.getElementById('bestScore').textContent = gameState.bestScore;
                localStorage.setItem('snakeRunnerBest', gameState.bestScore);
            }
            
            document.getElementById('finalScore').textContent = gameState.score;
            document.getElementById('finalLength').textContent = snake.body.length;
            document.getElementById('gameOver').style.display = 'block';
        }

        function restartGame() {
            document.getElementById('gameOver').style.display = 'none';
            resetGameState();
            gameState.gameOver = false;
            gameState.paused = false;
            gameLoop();
        }

        // Main game loop
        function gameLoop() {
            if (gameState.paused || gameState.gameOver || !gameState.gameStarted) return;
            
            update();
            draw();
            
            setTimeout(() => {
                if (gameState.gameStarted && !gameState.gameOver && !gameState.paused) {
                    gameLoop();
                }
            }, 150); // Game speed
        }

        // Initialize game
        initGame();
        draw();

        // Blocca lo scroll della pagina quando il gioco è attivo (es. frecce o barra spaziatrice)
        window.addEventListener("keydown", function (e) {
            if (!gameState.gameStarted) return;

            const blockedKeys = ["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight", " "];
            if (blockedKeys.includes(e.key)) {
                e.preventDefault();
            }
        }, { passive: false });

    </script>
    
</body>
</html>