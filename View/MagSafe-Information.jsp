<%@ page language="java"%>

<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechStore - Cover MagSafe</title>
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

        /* Header */
        .header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--white);
            padding: 1.5rem 2rem;
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo i {
            color: var(--secondary);
        }

        .nav-links {
            display: flex;
            gap: 2rem;
        }

        .nav-links a {
            color: var(--white);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
            padding: 0.5rem;
            border-radius: var(--radius-small);
        }

        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        /*SEZIONI COMUNI*/
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
            background: linear-gradient(135deg, #9b59b6, #8e44ad);
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

        /* Materiali Section */
        .materials-section {
            margin: 4rem 0;
        }

        .materials-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .material-card {
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

        .material-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-hover);
            border-color: var(--primary);
        }

        .material-image {
            width: 100%;
            height: 200px;
            object-fit: contain;
            margin-bottom: 1.5rem;
            transition: var(--transition);
        }

        .material-card:hover .material-image {
            transform: scale(1.05);
        }

        .material-title {
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
            color: var(--dark);
            transition: var(--transition);
        }

        .material-card:hover .material-title {
            color: var(--primary);
        }

        .material-description {
            color: var(--gray);
            font-size: 0.9rem;
        }

        /* Footer */
        .footer {
            background: var(--dark);
            color: var(--white);
            padding: 3rem 2rem;
            margin-top: 4rem;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .footer-section h3 {
            font-size: 1.4rem;
            margin-bottom: 1.5rem;
            position: relative;
            padding-bottom: 0.5rem;
        }

        .footer-section h3::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
        }

        .footer-links {
            list-style: none;
        }

        .footer-links li {
            margin-bottom: 0.8rem;
        }

        .footer-links a {
            color: #ddd;
            text-decoration: none;
            transition: var(--transition);
        }

        .footer-links a:hover {
            color: var(--primary);
            padding-left: 5px;
        }

        .copyright {
            text-align: center;
            padding-top: 2rem;
            margin-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #aaa;
            font-size: 0.9rem;
        }

        /*RESPONSIVE MEDIA*/
        @media (max-width: 768px) {
            .section-title {
                font-size: 2rem;
            }
            
            .header-content {
                flex-direction: column;
                gap: 1rem;
            }
            
            .nav-links {
                flex-wrap: wrap;
                justify-content: center;
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
                    <h1 class="hero-title">Cover MagSafe per iPhone</h1>
                    <p class="hero-description">
                        Scopri la rivoluzione delle cover MagSafe: perfetta adesione magnetica, ricarica wireless ottimizzata e compatibilita
                        con tutti gli accessori Apple MagSafe. Protezione premium senza compromessi, con un design sottile che mantiene intatta 
                        la funzionalita magnetica del tuo iPhone.
                    </p>
                    <button class="hero-btn" onclick="location.href='<%=request.getContextPath() + "/product" %>'">Scopri la collezione MagSafe</button>
                </div>
                <div class="hero-image">
                    <i class="fas fa-magnet"></i> Cover MagSafe
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="section-floating">
            <h2 class="section-title">Vantaggi delle Cover MagSafe</h2>
            
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-magnet"></i>
                    </div>
                    <h3 class="feature-title">Adesione Perfetta</h3>
                    <p class="feature-description">
                        Magneti perfettamente allineati per un attacco istantaneo e sicuro. La cover si aggancia al tuo iPhone con precisione 
                        millimetrica, senza mai spostarsi. Compatibile con tutti gli accessori MagSafe come wallet, supporti e power bank.
                    </p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <h3 class="feature-title">Ricarica Wireless Ottimizzata</h3>
                    <p class="feature-description">
                        Design ottimizzato per la ricarica MagSafe fino a 15W. Nessuna perdita di efficienza, la cover non interferisce con 
                        la ricarica wireless mantenendo la massima velocità. Strato magnetico integrato che non si indebolisce nel tempo.
                    </p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3 class="feature-title">Protezione Completa</h3>
                    <p class="feature-description">
                        Nonostante lo spessore ridotto, offre protezione militare MIL-STD-810G. Bordi rialzati per proteggere lo schermo e 
                        la fotocamera, con materiali antiurto che assorbono gli impatti senza aggiungere volume al dispositivo.
                    </p>
                </div>
            </div>
        </section>

        <!-- Materials Section -->
        <section class="section-floating">
            <h2 class="section-title">Tecnologia MagSafe</h2>
            
            <div class="materials-grid">
                <div class="material-card">
                    <div class="material-image" style="background: linear-gradient(135deg, #3498db, #2980b9); color: white;">
                        <i class="fas fa-magnet" style="font-size: 3rem;"></i>
                    </div>
                    <h3 class="material-title">Anello Magnetico Precisione</h3>
                    <p class="material-description">
                        Anello magnetico integrato con 18 magneti perfettamente allineati per garantire la massima aderenza e stabilità 
                        con tutti gli accessori MagSafe.
                    </p>
                </div>
                
                <div class="material-card">
                    <div class="material-image" style="background: linear-gradient(135deg, #e74c3c, #c0392b); color: white;">
                        <i class="fas fa-layer-group" style="font-size: 3rem;"></i>
                    </div>
                    <h3 class="material-title">Design a Strati</h3>
                    <p class="material-description">
                        Costruzione a più strati: policarbonato rigido esterno, TPU flessibile interno e strato magnetico intermedio per 
                        protezione totale senza compromessi.
                    </p>
                </div>
                
                <div class="material-card">
                    <div class="material-image" style="background: linear-gradient(135deg, #1abc9c, #16a085); color: white;">
                        <i class="fas fa-charging-station" style="font-size: 3rem;"></i>
                    </div>
                    <h3 class="material-title">Compatibilità Wireless</h3>
                    <p class="material-description">
                        Materiali appositamente studiati per non interferire con la ricarica wireless, mantenendo la massima efficienza 
                        energetica e prevenendo il surriscaldamento.
                    </p>
                </div>
                
                <div class="material-card">
                    <div class="material-image" style="background: linear-gradient(135deg, #9b59b6, #8e44ad); color: white;">
                        <i class="fas fa-fingerprint" style="font-size: 3rem;"></i>
                    </div>
                    <h3 class="material-title">Finestra NFC</h3>
                    <p class="material-description">
                        Area trasparente speciale che permette il passaggio del segnale NFC per pagamenti con Apple Pay senza dover 
                        rimuovere la cover.
                    </p>
                </div>
            </div>
        </section>

        <!-- Compatibility Section -->
        <section class="section-floating">
            <h2 class="section-title">Compatibilità MagSafe</h2>
            
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-mobile"></i>
                    </div>
                    <h3 class="feature-title">Modelli Supportati</h3>
                    <p class="feature-description">
                        Compatibile con tutti gli iPhone con MagSafe: iPhone 12, 13, 14, 15 e relativi modelli Pro, Pro Max e Mini. 
                        Taglio preciso per fotocamere e pulsanti, con bordi perfettamente aderenti.
                    </p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-wallet"></i>
                    </div>
                    <h3 class="feature-title">Accessori MagSafe</h3>
                    <p class="feature-description">
                        Piena compatibilità con wallet MagSafe, supporti da auto, power bank e tutti gli accessori ufficiali Apple e di 
                        terze parti certificati MagSafe.
                    </p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-car"></i>
                    </div>
                    <h3 class="feature-title">Supporti per Auto</h3>
                    <p class="feature-description">
                        Adesione magnetica potenziata per supporti da auto che mantiene il telefono saldamente in posizione anche su strade 
                        sconnesse. Facile da attaccare e staccare con una mano.
                    </p>
                </div>
            </div>
        </section>
    </div>
    
    <!-- Footer -->
    <%@ include file="includes/Footer.jsp" %>

</body>
</html>