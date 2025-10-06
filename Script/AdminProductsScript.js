document.addEventListener('DOMContentLoaded', function() {
    const productsPerPage = 4;
    let currentPage = 1;
    let allProducts = Array.from(document.querySelectorAll('#productsTable tbody tr'));
    let filteredProducts = [...allProducts];
    const sortSelect = document.getElementById('sortSelect');
    
    // Elementi modali
    const productModal = document.getElementById('productModal');
    const colorPickerModal = document.querySelector('.color-picker-panel');
    
    // initPagination();
    updateTableDisplay();
    


    // Selezione multipla
    document.getElementById('selectAll').addEventListener('change', function() {
        const checkboxes = document.querySelectorAll('.product-checkbox');
        checkboxes.forEach(checkbox => {
            if (checkbox !== this) checkbox.checked = this.checked;
        });
    });
    
    // Eliminazione multipla
    document.getElementById('deleteSelectedBtn').addEventListener('click', function() {
        const selectedProducts = Array.from(document.querySelectorAll('.product-checkbox:checked'))
            .filter(checkbox => checkbox.id !== 'selectAll');
        
        if (selectedProducts.length === 0) {
            alert('Seleziona almeno un prodotto da eliminare');
            return;
        }
        
        if (confirm(`Sei sicuro di voler eliminare ${selectedProducts.length} prodotti selezionati?`)) {
            selectedProducts.forEach(checkbox => {
                const row = checkbox.closest('tr');
                row.remove();
                allProducts = allProducts.filter(p => p !== row);
            });
            
            filterProducts();
            updatePagination();
            updateTableDisplay();
            document.getElementById('selectAll').checked = false;
        }
    });
    
    // Aggiunta nuovo prodotto
    document.getElementById('addProductBtn').addEventListener('click', function() {
        document.getElementById('modalTitle').textContent = 'Aggiungi Nuovo Prodotto';
        console.log("invocata");    
        resetProductForm();
        productModal.style.display = 'block';
        
        document.getElementById('productForm').onsubmit = function(e) {
            e.preventDefault();
            addNewProduct();
            productModal.style.display = 'none';
            return false;
        };
    });
    
    // Chiusura modale prodotto
    document.querySelector('#productModal .close-modal').addEventListener('click', function() {
        productModal.style.display = 'none';
    });
    
    // Chiusura modale prodotto con Annulla
    document.querySelector('#productModal .cancel-btn').addEventListener('click', function(e) {
        e.stopPropagation();
        productModal.style.display = 'none';
    });
    
    // Selezione colore
    document.getElementById('colorPickerBtn').addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        colorPickerModal.style.display = 'block';
        refreshElementRects();
    });

    // Chiusura color picker quando si clicca su Conferma
    document.getElementById('confirmColorBtn').addEventListener('click', function(e) {
        e.stopPropagation();
        colorPickerModal.style.display = 'none';
        return false;
    });

    // Chiusura color picker quando si clicca su Annulla
    document.querySelector('.color-picker-panel .cancel-btn').addEventListener('click', function(e) {
        e.stopPropagation();
        colorPickerModal.style.display = 'none';
        return false;
    });

    // Chiusura modali quando si clicca fuori
    document.addEventListener('click', function(e) {
        // Per il color picker
        if (!e.target.closest('.color-picker-panel') && 
            !e.target.closest('#colorPickerBtn') && 
            colorPickerModal.style.display === 'block') {
            colorPickerModal.style.display = 'none';
        }
        
        // Per il modal del prodotto
        if (!e.target.closest('.modal-content') && 
            !e.target.closest('#addProductBtn') && 
            !e.target.closest('.edit-btn') &&
            !e.target.closest('.color-picker-panel') &&
            productModal.style.display === 'block') {
            productModal.style.display = 'none';
        }
    });
    
    // Upload file
    document.getElementById('productImage').addEventListener('change', function() {
        const fileName = this.files[0]?.name || 'Nessun file selezionato';
        document.getElementById('fileName').textContent = fileName;
    });
    
    // Eliminazione singola
    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            if (confirm('Sei sicuro di voler eliminare questo prodotto?')) {
                const row = this.closest('tr');
                row.remove();
                allProducts = allProducts.filter(p => p !== row);
                filterProducts();
                updatePagination();
                updateTableDisplay();
            }
        });
    });
    
    // Modifica prodotto
    document.querySelectorAll('.edit-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const row = this.closest('tr');
            document.getElementById('modalTitle').textContent = 'Modifica Prodotto';
            
            document.getElementById('productName').value = row.cells[1].textContent.replace(/^Cover\s/, '').trim();
            document.getElementById('productCategory').value = row.cells[2].textContent.toLowerCase();
            document.getElementById('productPrice').value = parseFloat(row.cells[3].textContent.replace('€', '')).toFixed(2);
            document.getElementById('productStock').value = row.cells[4].textContent;            
            productModal.style.display = 'block';
            
            document.getElementById('productForm').onsubmit = function(e) {
                e.preventDefault();
                updateProduct(row);
                productModal.style.display = 'none';
                return false;
            };
        });
    });
    
    // Color picker
    if (document.querySelector('.color-picker-panel')) {
        const addSwatch = document.getElementById('add-swatch');
        const modeToggle = document.getElementById('mode-toggle');
        const swatches = document.querySelector('.default-swatches');
        const colorIndicator = document.getElementById('color-indicator');
        const userSwatches = document.getElementById('user-swatches');
        
        const spectrumCanvas = document.getElementById('spectrum-canvas');
        const spectrumCtx = spectrumCanvas.getContext('2d');
        const spectrumCursor = document.getElementById('spectrum-cursor'); 
        let spectrumRect = spectrumCanvas.getBoundingClientRect();
        
        const hueCanvas = document.getElementById('hue-canvas');
        const hueCtx = hueCanvas.getContext('2d');
        const hueCursor = document.getElementById('hue-cursor'); 
        let hueRect = hueCanvas.getBoundingClientRect();
        
        let currentColor = '';
        let hue = 0;
        let saturation = 1;
        let lightness = .5;
        
        const rgbFields = document.getElementById('rgb-fields');
        const hexField = document.getElementById('hex-field');
        
        const red = document.getElementById('red');
        const blue = document.getElementById('blue');
        const green = document.getElementById('green');
        const hex = document.getElementById('hex'); 

        // Funzioni del color picker
        function ColorPicker(){
            this.addDefaultSwatches();
            createShadeSpectrum();
            createHueSpectrum();
        };

        ColorPicker.prototype.defaultSwatches = [
            '#FFFFFF', '#FFFB0D', '#0532FF', '#FF9300', 
            '#00F91A', '#FF2700', '#000000', '#686868', 
            '#EE5464', '#D27AEE', '#5BA8C4', '#E64AA9'
        ];

        function createSwatch(target, color) {
            const swatch = document.createElement('button');
            swatch.classList.add('swatch');
            swatch.setAttribute('title', color);
            swatch.style.backgroundColor = color;
            swatch.addEventListener('click', function(){
                const color = tinycolor(this.style.backgroundColor);     
                colorToPos(color);
                setColorValues(color);
            });
            target.appendChild(swatch);
            refreshElementRects();
        };

        ColorPicker.prototype.addDefaultSwatches = function() {
            for(let i = 0; i < this.defaultSwatches.length; i++) {
                createSwatch(swatches, this.defaultSwatches[i]);
            } 
        };

        function refreshElementRects(){
            spectrumRect = spectrumCanvas.getBoundingClientRect();
            hueRect = hueCanvas.getBoundingClientRect();
        }

        function createShadeSpectrum(color) {
            if(!color) color = '#f00';
            spectrumCtx.fillStyle = color;
            spectrumCtx.fillRect(0, 0, spectrumCanvas.width, spectrumCanvas.height);

            const whiteGradient = spectrumCtx.createLinearGradient(0, 0, spectrumCanvas.width, 0);
            whiteGradient.addColorStop(0, "#fff");
            whiteGradient.addColorStop(1, "transparent");
            spectrumCtx.fillStyle = whiteGradient;
            spectrumCtx.fillRect(0, 0, spectrumCanvas.width, spectrumCanvas.height);

            const blackGradient = spectrumCtx.createLinearGradient(0, 0, 0, spectrumCanvas.height);
            blackGradient.addColorStop(0, "transparent");
            blackGradient.addColorStop(1, "#000");
            spectrumCtx.fillStyle = blackGradient;
            spectrumCtx.fillRect(0, 0, spectrumCanvas.width, spectrumCanvas.height);

            spectrumCanvas.addEventListener('mousedown', startGetSpectrumColor);
        };

        function createHueSpectrum() {
            const hueGradient = hueCtx.createLinearGradient(0, 0, 0, hueCanvas.height);
            hueGradient.addColorStop(0.00, "hsl(0,100%,50%)");
            hueGradient.addColorStop(0.17, "hsl(298.8, 100%, 50%)");
            hueGradient.addColorStop(0.33, "hsl(241.2, 100%, 50%)");
            hueGradient.addColorStop(0.50, "hsl(180, 100%, 50%)");
            hueGradient.addColorStop(0.67, "hsl(118.8, 100%, 50%)");
            hueGradient.addColorStop(0.83, "hsl(61.2,100%,50%)");
            hueGradient.addColorStop(1.00, "hsl(360,100%,50%)");
            hueCtx.fillStyle = hueGradient;
            hueCtx.fillRect(0, 0, hueCanvas.width, hueCanvas.height);
            hueCanvas.addEventListener('mousedown', startGetHueColor);
        };

        function colorToHue(color) {
            const hsl = tinycolor(color).toHsl();
            return tinycolor(`hsl ${hsl.h} 1 .5`).toHslString();
        };

        function colorToPos(color) {
            const tc = tinycolor(color);
            const hsl = tc.toHsl();
            hue = hsl.h;
            const hsv = tc.toHsv();
            const x = spectrumRect.width * hsv.s;
            const y = spectrumRect.height * (1 - hsv.v);
            const hueY = hueRect.height - ((hue / 360) * hueRect.height);
            
            updateSpectrumCursor(x, y);
            updateHueCursor(hueY);
            setCurrentColor(tc);
            createShadeSpectrum(colorToHue(tc));
            refreshElementRects(); 
        };

        function setColorValues(color) {  
            const tc = tinycolor(color);
            const rgbValues = tc.toRgb();
            red.value = rgbValues.r;
            green.value = rgbValues.g;
            blue.value = rgbValues.b;
            hex.value = tc.toHex();
        };

        function setCurrentColor(color) {
            const tc = tinycolor(color);
            currentColor = tc;
            colorIndicator.style.backgroundColor = tc;
            spectrumCursor.style.backgroundColor = tc; 
            hueCursor.style.backgroundColor = `hsl(${tc.toHsl().h}, 100%, 50%)`;
            
            // Aggiorna l'anteprima colore nel form prodotto
            document.getElementById('colorPreview').style.backgroundColor = tc;
            document.getElementById('productColor').value = tc.toHex();
        };

        function updateHueCursor(y) {
            hueCursor.style.top = `${y}px`;
        }

        function updateSpectrumCursor(x, y) {
            spectrumCursor.style.left = `${x}px`;
            spectrumCursor.style.top = `${y}px`;  
        };

        const startGetSpectrumColor = function(e) {
            getSpectrumColor(e);
            spectrumCursor.classList.add('dragging');
            window.addEventListener('mousemove', getSpectrumColor);
            window.addEventListener('mouseup', endGetSpectrumColor);
        };

        function getSpectrumColor(e) {
            e.preventDefault();
            let x = e.pageX - spectrumRect.left;
            let y = e.pageY - spectrumRect.top;
            
            x = Math.max(0, Math.min(x, spectrumRect.width));
            y = Math.max(0, Math.min(y, spectrumRect.height));
            
            const xRatio = x / spectrumRect.width * 100;
            const yRatio = y / spectrumRect.height * 100; 
            const hsvValue = 1 - (yRatio / 100);
            const hsvSaturation = xRatio / 100;
            
            lightness = (hsvValue / 2) * (2 - hsvSaturation);
            saturation = (hsvValue * hsvSaturation) / (1 - Math.abs(2 * lightness - 1));
            
            const color = tinycolor(`hsl ${hue} ${saturation} ${lightness}`);
            setCurrentColor(color);  
            setColorValues(color);
            updateSpectrumCursor(x, y);
        };

        function endGetSpectrumColor() {
            spectrumCursor.classList.remove('dragging');
            window.removeEventListener('mousemove', getSpectrumColor);
        };

        const startGetHueColor = function(e) {
            getHueColor(e);
            hueCursor.classList.add('dragging');
            window.addEventListener('mousemove', getHueColor);
            window.addEventListener('mouseup', endGetHueColor);
        };

        function getHueColor(e) {
            e.preventDefault();
            let y = e.pageY - hueRect.top;
            y = Math.max(0, Math.min(y, hueRect.height));  
            
            const percent = y / hueRect.height;
            hue = 360 - (360 * percent);
            const hueColor = tinycolor(`hsl ${hue} 1 .5`).toHslString();
            const color = tinycolor(`hsl ${hue} ${saturation} ${lightness}`).toHslString();
            
            createShadeSpectrum(hueColor);
            updateHueCursor(y);
            setCurrentColor(color);
            setColorValues(color);
        };

        function endGetHueColor() {
            hueCursor.classList.remove('dragging');
            window.removeEventListener('mousemove', getHueColor);
        };

        // Event listeners
        red.addEventListener('change', function() {
            const color = tinycolor(`rgb ${red.value} ${green.value} ${blue.value}`);
            colorToPos(color);
        });

        green.addEventListener('change', function() {
            const color = tinycolor(`rgb ${red.value} ${green.value} ${blue.value}`);
            colorToPos(color);
        });

        blue.addEventListener('change', function() {
            const color = tinycolor(`rgb ${red.value} ${green.value} ${blue.value}`);
            colorToPos(color);
        });

        addSwatch.addEventListener('click', function() {  
            createSwatch(userSwatches, currentColor);
        });

        modeToggle.addEventListener('click', function() {
            rgbFields.classList.toggle('active');
            hexField.classList.toggle('active');
        });

        window.addEventListener('resize', refreshElementRects);

        new ColorPicker();
    }

    // Funzioni helper
    function filterProducts() {
        const category = document.getElementById('categoryFilter').value;
        filteredProducts = allProducts.filter(row => {
            return category === 'all' || row.cells[2].textContent.toLowerCase() === category;
        });
    }
    
    function applyCurrentSort() {
        const sortValue = sortSelect.value;

        filteredProducts.sort((a, b) => {
            const priceTextA = a.querySelector('td:nth-child(4)').innerText;
            const priceTextB = b.querySelector('td:nth-child(4)').innerText;
            const priceA = parseFloat(priceTextA.replace(/[^\d,]/g, '').replace(',', '.'));
            const priceB = parseFloat(priceTextB.replace(/[^\d,]/g, '').replace(',', '.'));

            const nameA = a.querySelector('td:nth-child(2)').innerText.toLowerCase();
            const nameB = b.querySelector('td:nth-child(2)').innerText.toLowerCase();

            switch (sortValue) {
                case 'price-asc': return priceA - priceB;
                case 'price-desc': return priceB - priceA;
                case 'name-asc': return nameA.localeCompare(nameB);
                case 'name-desc': return nameB.localeCompare(nameA);
                default: return 0;
            }
        });
    }
    
    function updateTableDisplay() {
        const tbody = document.querySelector('#productsTable tbody');
        tbody.innerHTML = '';
        
        const startIdx = (currentPage - 1) * productsPerPage;
        const productsToShow = filteredProducts.slice(startIdx, startIdx + productsPerPage);
        productsToShow.forEach(row => tbody.appendChild(row));
    }
    
    // function initPagination() {
    //     updatePagination();
    // }
    
    // function updatePagination() {
    //     const totalPages = Math.ceil(filteredProducts.length / productsPerPage);
    //     const pagination = document.querySelector('.pagination');
    //     pagination.innerHTML = '';
        
    //     const prevBtn = document.createElement('button');
    //     prevBtn.className = 'page-btn prev-btn';
    //     prevBtn.innerHTML = '<i class="fas fa-chevron-left"></i>';
    //     prevBtn.disabled = currentPage === 1;
    //     pagination.appendChild(prevBtn);
        
    //     for (let i = 1; i <= totalPages; i++) {
    //         const pageBtn = document.createElement('button');
    //         pageBtn.className = 'page-btn' + (i === currentPage ? ' active' : '');
    //         pageBtn.textContent = i;
    //         pagination.appendChild(pageBtn);
    //     }
        
    //     const nextBtn = document.createElement('button');
    //     nextBtn.className = 'page-btn next-btn';
    //     nextBtn.innerHTML = '<i class="fas fa-chevron-right"></i>';
    //     nextBtn.disabled = currentPage >= totalPages || totalPages === 0;
    //     pagination.appendChild(nextBtn);
    // }
    
    function resetProductForm() {
        document.getElementById('productForm').reset();
        document.getElementById('fileName').textContent = 'Nessun file selezionato';
        document.getElementById('colorPreview').style.backgroundColor = '#FFFFFF';
        document.getElementById('productColor').value = '';
    }
    
    function addNewProduct() {
        const tbody = document.querySelector('#productsTable tbody');
        const newRow = document.createElement('tr');
        
        newRow.innerHTML = `
            <td><input type="checkbox" class="product-checkbox"></td>
            <td><img src="img/cover/default.png" class="product-img"> ${document.getElementById('productName').value}</td>
            <td>${document.getElementById('productCategory').value}</td>
            <td>€${parseFloat(document.getElementById('productPrice').value).toFixed(2)}</td>
            <td>${document.getElementById('productStock').value}</td>
            <td>
                <button class="edit-btn"><i class="fas fa-edit"></i></button>
                <button class="delete-btn"><i class="fas fa-trash"></i></button>
            </td>
        `;
        
        tbody.appendChild(newRow);
        allProducts = Array.from(document.querySelectorAll('#productsTable tbody tr'));
        filterProducts();
        updatePagination();
        updateTableDisplay();
        
        // Aggiungi gestori eventi per la nuova riga
        newRow.querySelector('.delete-btn').addEventListener('click', function() {
            if (confirm('Sei sicuro di voler eliminare questo prodotto?')) {
                newRow.remove();
                allProducts = allProducts.filter(p => p !== newRow);
                filterProducts();
                updatePagination();
                updateTableDisplay();
            }
        });
        
        newRow.querySelector('.edit-btn').addEventListener('click', function() {
            document.getElementById('modalTitle').textContent = 'Modifica Prodotto';
            document.getElementById('productName').value = newRow.cells[1].textContent.replace(/^Cover\s/, '').trim();
            document.getElementById('productCategory').value = newRow.cells[2].textContent.toLowerCase();
            document.getElementById('productPrice').value = parseFloat(newRow.cells[3].textContent.replace('€', '')).toFixed(2);
            document.getElementById('productStock').value = newRow.cells[4].textContent;
            productModal.style.display = 'block';
            
            document.getElementById('productForm').onsubmit = function(e) {
                e.preventDefault();
                updateProduct(newRow);
                productModal.style.display = 'none';
                return false;
            };
        });
    }
    
    function updateProduct(row) {
        row.cells[1].innerHTML = `<img src="img/cover/default.png" class="product-img"> ${document.getElementById('productName').value}`;
        row.cells[2].textContent = document.getElementById('productCategory').value;
        row.cells[3].textContent = `€${parseFloat(document.getElementById('productPrice').value).toFixed(2)}`;
        row.cells[4].textContent = document.getElementById('productStock').value;

        filterProducts();
        applyCurrentSort();
        updateTableDisplay();
    }
});