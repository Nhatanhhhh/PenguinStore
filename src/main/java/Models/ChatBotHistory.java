package Models;

import java.util.UUID;
import java.util.Date;

public class ChatBotHistory {

    private UUID historyID;
    private UUID customerID;
    private String customerName;
    private String question;
    private String answer;
    private Date questionDate;
    private boolean isAnswered;

    // Constructors
    public ChatBotHistory() {
    }

    public ChatBotHistory(UUID historyID, UUID customerID, String customerName, String question,
            String answer, Date questionDate, boolean isAnswered) {
        this.historyID = historyID;
        this.customerID = customerID;
        this.customerName = customerName;
        this.question = question;
        this.answer = answer;
        this.questionDate = questionDate;
        this.isAnswered = isAnswered;
    }

    // Getters and Setters
    public UUID getHistoryID() {
        return historyID;
    }

    public void setHistoryID(UUID historyID) {
        this.historyID = historyID;
    }

    public UUID getCustomerID() {
        return customerID;
    }

    public void setCustomerID(UUID customerID) {
        this.customerID = customerID;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public Date getQuestionDate() {
        return questionDate;
    }

    public void setQuestionDate(Date questionDate) {
        this.questionDate = questionDate;
    }

    public boolean isAnswered() {
        return isAnswered;
    }

    public void setAnswered(boolean answered) {
        isAnswered = answered;
    }
}
