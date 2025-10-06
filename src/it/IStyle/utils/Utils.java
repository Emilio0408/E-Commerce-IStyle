package it.IStyle.utils;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import it.IStyle.model.bean.Feedback;
import it.IStyle.model.bean.ProductBean;

public class Utils 
{

    public static String hashPassword(String password) 
    {
        try 
        {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());

            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b)); // converte in esadecimale
            }

            return sb.toString();           
        } 
        catch (NoSuchAlgorithmException e) 
        {
            throw new RuntimeException("Errore nell'hashing della password", e);
        }
    }

    public static boolean checkPassword(String password, String hashedPassword) 
    {
        return hashPassword(password).equals(hashedPassword);
    }



    public static boolean checkParameters(HttpServletRequest request, String...Parameters )
    {
        for(String p : Parameters)
        {   
            String tmp = request.getParameter(p);
            if(tmp == null || tmp.trim().isEmpty())
                return false;
        }
    
        return true;
    }  

    public static void sendJsonResponse(HttpServletResponse response, boolean success, String redirectURL, String error) throws IOException
    {   
        JsonObject json = new JsonObject();
        json.addProperty("success", success);

        if(success && redirectURL != null)
            json.addProperty("redirectURL", redirectURL);
        else if( !(success) && error != null)
            json.addProperty("error", error);

        sendJsonResponse(response, json.toString());
    }


    public static void sendJsonResponse(HttpServletResponse response, Boolean success, Object data) throws IOException
    {
        HashMap<String,Object> responseData = new HashMap<String,Object>();
        responseData.put("success", success);
        responseData.put("data", data);
        String json = new Gson().toJson(responseData);
        sendJsonResponse(response, json);
    }


    public static void sendJsonResponse(HttpServletResponse response, String responseContent) throws IOException
    {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(responseContent);
    }


    public static int tryParseInt(String value, int defaultValue) 
    {
        try 
        {
            return Integer.parseInt(value);
        } 
        catch (NumberFormatException e) 
        {
            return defaultValue;
        }
    }


    public static double getFeedbacksAverage(LinkedList<Feedback> feedbacks)
    {
        if(feedbacks == null || feedbacks.size() == 0)
            return 0.0;

        int sum = 0;
        double Average = 0.0;
        for(Feedback f : feedbacks)
        {
            sum += f.getVote();
        }

        Average = sum / feedbacks.size();

        return Average;
    }

    public static Map<Integer, Integer> getVotePercentages(List<Feedback> feedbackList) 
    {
        Map<Integer, Integer> voteCount = new HashMap<>();
        int totalVotes = feedbackList.size();

        // Inizializza contatori da 1 a 5 stelle
        for (int i = 1; i <= 5; i++) {
            voteCount.put(i, 0);
        }

        // Conta i voti
        for (Feedback feedback : feedbackList) {
            int vote = (int) feedback.getVote();
            voteCount.put(vote, voteCount.getOrDefault(vote, 0) + 1);
        }

        // Calcola le percentuali
        Map<Integer, Integer> votePercentages = new HashMap<>();
        for (int i = 1; i <= 5; i++) {
            int count = voteCount.get(i);
            int percentage = totalVotes > 0 ? (int) Math.round((count * 100.0) / totalVotes) : 0;
            votePercentages.put(i, percentage);
        }

        return votePercentages;
    }


    public static LinkedList<ProductBean> getCasualProducts(LinkedList<ProductBean> allProducts, int n_products)
    {
        if (allProducts == null || allProducts.isEmpty() || n_products <= 0) 
        {
                return new LinkedList<>();
        }

        if (n_products >= allProducts.size()) 
        {
            return new LinkedList<>(allProducts);
        }

        LinkedList<ProductBean> casualProducts = new LinkedList<>();
        Set<Integer> usedIndices = new HashSet<>();
        Random random = new Random();

        while (casualProducts.size() < n_products) 
        {
            int randomIndex = random.nextInt(allProducts.size());
            if (!usedIndices.contains(randomIndex)) 
            {
                usedIndices.add(randomIndex);
                casualProducts.add(allProducts.get(randomIndex));
            }
        }

        return casualProducts;
    }




}
