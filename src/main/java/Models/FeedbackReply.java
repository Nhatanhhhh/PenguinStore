/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.util.Date;

/**
 *
 * @author Thuan
 */
public class FeedbackReply {
    private String replyId;
    private String feedbackId;
    private String managerId;
    private String replyComment;
    private Date feedRepCreateAt;

    public FeedbackReply(String replyId, String feedbackId, String managerId, String replyComment, Date feedRepCreateAt) {
        this.replyId = replyId;
        this.feedbackId = feedbackId;
        this.managerId = managerId;
        this.replyComment = replyComment;
        this.feedRepCreateAt = feedRepCreateAt;
    }

    public FeedbackReply() {
    }

    public String getReplyId() {
        return replyId;
    }

    public void setReplyId(String replyId) {
        this.replyId = replyId;
    }

    public String getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(String feedbackId) {
        this.feedbackId = feedbackId;
    }

    public String getManagerId() {
        return managerId;
    }

    public void setManagerId(String managerId) {
        this.managerId = managerId;
    }

    public String getReplyComment() {
        return replyComment;
    }

    public void setReplyComment(String replyComment) {
        this.replyComment = replyComment;
    }

    public Date getFeedRepCreateAt() {
        return feedRepCreateAt;
    }

    public void setFeedRepCreateAt(Date feedRepCreateAt) {
        this.feedRepCreateAt = feedRepCreateAt;
    }
    
    
}
