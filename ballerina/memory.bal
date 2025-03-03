public type Memory isolated object {
    public isolated function get() returns ChatMessage[]|error;
    public isolated function update(ChatMessage message) returns error?;
    public isolated function delete() returns error?;
};

public isolated class MessageWindowChatMemory{
    *Memory;
    final int k;
    private ChatMessage[] chatHistory = [];

    public isolated function init(int k = 10) {
        self.k = k;
    }
    public isolated function get() returns ChatMessage[]|error {
        lock{
            return self.chatHistory.clone();
        }
    }
    public isolated function update(ChatMessage message) returns error? {
        lock{
            if (message is ChatSystemMessage) {
                self.enqueSystemPrompt(self.chatHistory, message.clone());
                return;
            }

            if (self.chatHistory.length() == self.k) {
            _ = self.deque(self.chatHistory);
            }
            self.enque(self.chatHistory, message.clone());
        }
    }
    
    public isolated function delete() returns error? {
        lock{
            self.chatHistory.removeAll();
        }
    }

    private isolated function enque(ChatMessage[] chatHistory, ChatMessage message) {
        chatHistory.push(message);
    }

    private isolated function deque(ChatMessage[] chatHistory) returns ChatMessage? {
        if (chatHistory.length() == 0) {
            return ();  // if not handled shift will panic for empty array
        }
        return chatHistory.remove(1); 
    }

    private isolated function enqueSystemPrompt(ChatMessage[] chatHistory, ChatMessage message) {
        if(chatHistory.length() == self.k){
            chatHistory[0] = message;
        }else{
            if(chatHistory[0] is ChatSystemMessage){
                chatHistory[0] = message;
            } else{
                chatHistory.unshift(message);
            }
        }
    }

}


