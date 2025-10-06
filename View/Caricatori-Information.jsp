<%@ page language="java" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechStore - Caricatori e Accessori</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1e89e3;
            --primary-hover: #156ab3;
            --secondary: #e75919;
            --secondary-hover: #c44a15;
            --dark: #2a2a2a;
            --gray: #6c757d;
            --light: #f8f9fa;
            --light-bg: #f1f5f9;
            --white: #ffffff;
            --border: #e0e0e0;
            --radius: 12px;
            --radius-small: 8px;
            --shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            --shadow-hover: 0 15px 40px rgba(0, 0, 0, 0.15);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: var(--light-bg);
            color: var(--dark);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Sezioni Comuni */
        .section-title {
            text-align: center;
            font-size: 2.5rem;
            margin: 4rem 0 2rem;
            font-weight: 700;
            color: var(--dark);
            position: relative;
            padding-bottom: 1rem;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            border-radius: 2px;
        }

        .section-floating {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 3rem 2rem;
            margin: 3rem auto;
            max-width: 1200px;
            transition: var(--transition);
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
        }

        .section-floating:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
            border-color: rgba(30, 137, 227, 0.3);
        }

        .section-floating::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle at 20% 30%, rgba(30, 137, 227, 0.05) 0%, transparent 50%);
            z-index: -1;
            transition: var(--transition);
        }

        .section-floating:hover::before {
            background: radial-gradient(circle at 20% 30%, rgba(30, 137, 227, 0.1) 0%, transparent 50%);
        }

        /* Hero Section */
        .hero-section {
            display: flex;
            align-items: center;
            gap: 3rem;
            margin-bottom: 3rem;
        }

        .hero-content {
            flex: 1;
        }

        .hero-image {
            flex: 1;
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow);
            height: 400px;
            background: linear-gradient(135deg, #f39c12, #e67e22);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
        }

        .hero-title {
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            color: var(--dark);
        }

        .hero-description {
            font-size: 1.1rem;
            color: var(--gray);
            margin-bottom: 2rem;
            line-height: 1.8;
        }

        .hero-btn {
            background: linear-gradient(135deg, var(--primary), var(--primary-hover));
            color: var(--white);
            border: none;
            border-radius: 30px;
            padding: 0.8rem 1.5rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: inline-block;
        }

        .hero-btn:hover {
            background: linear-gradient(135deg, var(--primary-hover), #1268b5);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(30, 137, 227, 0.3);
        }

        /* Features Section */
        .features-section {
            margin: 4rem 0;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .feature-card {
            background: var(--white);
            border-radius: var(--radius);
            padding: 2rem;
            text-align: center;
            box-shadow: var(--shadow);
            transition: var(--transition);
            border: 1px solid var(--border);
            position: relative;
            overflow: hidden;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-hover);
            border-color: var(--primary);
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            transition: var(--transition);
        }

        .feature-card:hover::before {
            height: 6px;
        }

        .feature-icon {
            width: 70px;
            height: 70px;
            margin: 0 auto 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            color: var(--white);
            font-size: 1.8rem;
            transition: var(--transition);
        }

        .feature-card:hover .feature-icon {
            transform: scale(1.1);
            box-shadow: 0 8px 20px rgba(30, 137, 227, 0.3);
        }

        .feature-title {
            font-size: 1.4rem;
            margin-bottom: 1rem;
            color: var(--dark);
            transition: var(--transition);
        }

        .feature-card:hover .feature-title {
            color: var(--primary);
        }

        .feature-description {
            color: var(--gray);
            font-size: 1rem;
        }

        /* Products Section */
        .products-section {
            margin: 4rem 0;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .product-card {
            background: var(--white);
            border-radius: var(--radius);
            padding: 1.5rem;
            text-align: center;
            box-shadow: var(--shadow);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
            border: 1px solid var(--border);
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-hover);
            border-color: var(--primary);
        }

        .product-image {
            width: 100%;
            height: 200px;
            object-fit: contain;
            margin-bottom: 1.5rem;
            transition: var(--transition);
        }

        .product-card:hover .product-image {
            transform: scale(1.05);
        }

        .product-title {
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
            color: var(--dark);
            transition: var(--transition);
        }

        .product-card:hover .product-title {
            color: var(--primary);
        }

        .product-description {
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .section-title {
                font-size: 2rem;
            }
            
            .hero-section {
                flex-direction: column;
            }
            
            .hero-image {
                width: 100%;
                height: 300px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <%@ include file="includes/Header.jsp" %>


    <div class="container">
        <!-- Hero Section -->
        <section class="section-floating">
            <div class="hero-section">
                <div class="hero-content">
                    <h1 class="hero-title">Caricatori ad Alta Velocità</h1>
                    <p class="hero-description">
                        Ricarica i tuoi dispositivi in tempi record con i nostri caricatori di ultima generazione. Tecnologia 
                        Power Delivery e Quick Charge per una ricarica rapida e sicura di smartphone, tablet e laptop. 
                        Costruiti con materiali premium per durare nel tempo.
                    </p>
                    <button class="hero-btn">Scopri la gamma</button>
                </div>
                <div class="hero-image">
                    <i class="fas fa-bolt"></i> Caricatori Ultra Veloce
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="section-floating">
            <h2 class="section-title">Perché Scegliere i Nostri Caricatori</h2>
            
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-tachometer-alt"></i>
                    </div>
                    <h3 class="feature-title">Ricarica Ultra Veloce</h3>
                    <p class="feature-description">
                        Tecnologia Power Delivery 3.0 e Quick Charge 4+ per ricaricare il tuo dispositivo fino al 50% in soli 30 minuti. 
                        Compatibile con la maggior parte degli smartphone e tablet.
                    </p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3 class="feature-title">Protezione Integrata</h3>
                    <p class="feature-description">
                        Circuiti intelligenti proteggono da sovratensioni, surriscaldamento e cortocircuiti. 
                        Carica in tutta sicurezza senza rischiare di danneggiare i tuoi dispositivi.
                    </p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-route"></i>
                    </div>
                    <h3 class="feature-title">Portabilità</h3>
                    <p class="feature-description">
                        Design compatto e leggero per portare sempre con te la potenza di cui hai bisogno. 
                        Ideale per viaggi, ufficio e uso quotidiano.
                    </p>
                </div>
            </div>
        </section>

        <!-- Products Section -->
        <section class="section-floating">
            <h2 class="section-title">La Nostra Gamma di Caricatori</h2>
            
            <div class="products-grid">
                <div class="product-card">
                    <div class="product-image" style="background: linear-gradient(135deg, #3498db, #2980b9); color: white;">
                        <i class="fas fa-charging-station" style="font-size: 3rem;"></i>
                    </div>
                    <h3 class="product-title">Caricatore USB-C 30W</h3>
                    <p class="product-description">
                        Caricatore compatto con tecnologia GaN per ricariche ultra veloci. Ideale per smartphone e tablet.
                    </p>
                </div>
                
                <div class="product-card">
                    <div class="product-image" style="background: linear-gradient(135deg, #e74c3c, #c0392b); color: white;">
                        <i class="fas fa-plug" style="font-size: 3rem;"></i>
                    </div>
                    <h3 class="product-title">Caricatore Wireless 15W</h3>
                    <p class="product-description">
                        Base di ricarica wireless Qi compatibile con tutti gli smartphone abilitati. Design elegante e antiscivolo.
                    </p>
                </div>
                
                <div class="product-card">
                    <div class="product-image" style="background: linear-gradient(135deg, #1abc9c, #16a085); color: white;">
                        <i class="fas fa-laptop" style="font-size: 3rem;"></i>
                    </div>
                    <h3 class="product-title">Caricatore 65W PD</h3>
                    <p class="product-description">
                        Potente caricatore per laptop e dispositivi USB-C. Ricarica il tuo MacBook Pro fino al 50% in 40 minuti.
                    </p>
                </div>
                

            </div>
        </section>

        <!-- Compatibility Section -->
        <section class="section-floating">
            <h2 class="section-title">Compatibilità Universale</h2>
            
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-mobile"></i>
                    </div>
                    <h3 class="feature-title">Tutti i Dispositivi</h3>
                    <p class="feature-description">
                        Compatibili con iPhone, Samsung, Google Pixel, Huawei e tutti i principali brand. Supporto per USB-A, USB-C e Lightning.
                    </p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-laptop"></i>
                    </div>
                    <h3 class="feature-title">Laptop e Tablet</h3>
                    <p class="feature-description">
                        Alcuni dei nostri caricatori supportano la ricarica di laptop e tablet grazie alla tecnologia Power Delivery.
                    </p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-globe"></i>
                    </div>
                    <h3 class="feature-title">Tensione Internazionale</h3>
                    <p class="feature-description">
                        Funzionano con tensioni da 100V a 240V, ideali per i viaggiatori. Adattatori opzionali disponibili.
                    </p>
                </div>
            </div>
        </section>
    </div>
    
    <!-- Footer -->
    <%@ include file="includes/Footer.jsp" %>

</body>
</html>