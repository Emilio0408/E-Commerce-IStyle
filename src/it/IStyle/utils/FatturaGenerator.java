package it.IStyle.utils;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.Standard14Fonts;
import org.apache.pdfbox.pdmodel.graphics.image.LosslessFactory;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import java.awt.image.BufferedImage;
import it.IStyle.model.bean.Order;
import it.IStyle.model.bean.ProductBean;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.LinkedList;
import java.io.File;
import javax.imageio.ImageIO;

public class FatturaGenerator 
{


    public static void generaFattura(Order order, String nomeCliente, String cognomeCliente, String emailCliente, String relativePath) throws IOException 
    {

        PDDocument document = new PDDocument();
        PDPage page = new PDPage(PDRectangle.A4);
        document.addPage(page);

        PDPageContentStream content = new PDPageContentStream(document, page);
        content.setLeading(15f); //Setta di quanto deve scendere ad ogni newLine
        content.beginText(); //Prepara un operazione di inserimento testo



        float startX = 50;         // margine sinistro
        float startY = 750;        // posizione iniziale

        content.setFont(new PDType1Font(Standard14Fonts.FontName.HELVETICA_BOLD), 18);
        content.newLineAtOffset(startX, startY);

        // Intestazione
        content.showText("Fattura n° " + order.getIDOrdine());
        content.newLine();
        content.newLine();
        startY -= 30f; //Ogni volta che eseguiamo un newLine cambiamo il valore di startY per tenere traccia della posizione verticale del cursore

        // Dati Cliente
        content.setFont(new PDType1Font(Standard14Fonts.FontName.HELVETICA_BOLD), 14);
        content.showText("Cliente:");
        content.newLine();

        content.setFont(new PDType1Font(Standard14Fonts.FontName.HELVETICA), 10);
        content.showText(nomeCliente + " " + cognomeCliente);
        content.newLine();

        content.showText("Email: " + emailCliente);
        content.newLine();
        
        content.showText("Indirizzo: " + order.getIndirizzoDiSpedizione());
        content.newLine();
        content.newLine();

        startY -= 75f;


        // Dettagli ordine
        content.setFont(new PDType1Font(Standard14Fonts.FontName.HELVETICA_BOLD), 14);
        content.showText("Dettagli ordine:");
        content.newLine();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        content.setFont(new PDType1Font(Standard14Fonts.FontName.HELVETICA_BOLD), 10);
        content.showText("Data Ordine: " + sdf.format(order.getDataEmissione()));
        content.newLine();
        content.showText("Totale ordine: € " + String.format("%.2f", order.getImportoTotale()));
        content.newLine();
        content.newLine();

        startY -= 60f;
        content.endText();



        // Visualizzazione prodotti dell'ordine
        LinkedList<ProductBean> productsInOrder = order.getProductsInOrder();
        float imageWidth = 80;
        float imageHeight = 80;
        float spaceBetween = 10;
        startY -= 65f;
        
        for (ProductBean p : productsInOrder) 
        {
        // Percorso assoluto all'immagine del prodotto
            LinkedList<String> ImagesPathsOfProduct = p.getImagesPaths();
            String finalPath = "";
            for(String path : ImagesPathsOfProduct)
            {
                if(path.contains(p.getColor()))
                    finalPath = path;
            }

            String imagePath = relativePath + "images/prodotti/" + finalPath;
            File imageFile = new File(imagePath);

            // Debug: stampa il percorso assoluto per verifica
            System.out.println("Trying to load image from: " + imageFile.getAbsolutePath());
            BufferedImage bufferedImage = ImageIO.read(imageFile);
            PDImageXObject image = LosslessFactory.createFromImage(document, bufferedImage);


            // Disegna l'immagine
            content.drawImage(image, startX, startY, imageWidth, imageHeight);

            // Riapri il blocco testo accanto all'immagine
            content.beginText();
            content.setFont(new PDType1Font(Standard14Fonts.FontName.HELVETICA), 10);
            content.newLineAtOffset(startX + imageWidth + spaceBetween, startY + imageHeight - 30); // posiziona in alto rispetto all'immagine

            // Riga 1: Nome prodotto
            content.showText("Prodotto:" + p.getName());
            content.newLineAtOffset(0, -15);

            // Riga 2: Quantità
            content.showText("Quantità: " + p.getQuantityInCart());
            content.newLineAtOffset(0, -15);

            // Riga 3: Prezzo
            content.showText("Prezzo unitario: € " + String.format("%.2f", p.getPrice()));
            content.newLineAtOffset(0, -15);


            //Riga 4: Colore
            content.showText("Colore:" + p.getColor());
            content.newLineAtOffset(0, -15);


            //Riga 5: Modello
            content.showText("Modello: " + p.getModel());
            content.endText();

            // Aggiorna Y per il prossimo prodotto (spazio tra prodotti)
            startY -= (imageHeight + 20);
        }

        content.beginText();
        content.newLineAtOffset(startX, startY);
        content.setFont(new PDType1Font(Standard14Fonts.FontName.HELVETICA), 12);
        content.showText("Grazie per aver acquistato da IStyle!");
        
        content.endText();
        content.close();

        String fileName = "fattura_" + order.getIDOrdine() + ".pdf";
        document.save(relativePath + "/pdf/fatture/" + fileName);

    }

}
