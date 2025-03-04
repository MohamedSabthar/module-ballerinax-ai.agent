public type Memory isolated object {
    public isolated function get() returns ChatMessage[]|error;
    public isolated function update(ChatMessage message) returns error?;
    public isolated function delete() returns error?;
};

public isolated class MessageWindowChatMemory {
    *Memory;
    final int size;
    private ChatSystemMessage? systemPrompt = ();
    private final ChatMessage[] memory = [];

    public isolated function init(int size = 10) {
        self.size = size;
    }

    public isolated function get() returns ChatMessage[]|error {
        lock {
            ChatMessage[] memory = self.memory.clone();
            ChatSystemMessage? systemPrompt = self.systemPrompt;
            if systemPrompt is ChatSystemMessage {
                memory.unshift(systemPrompt);
            }
            return memory.clone();
        }
    }

    public isolated function update(ChatMessage message) returns error? {
        lock {
            if message is ChatSystemMessage {
                self.systemPrompt = message.clone();
                return;
            }
            if self.memory.length() >= self.size - 1 {
                _ = self.memory.shift();
            }
            self.memory.push(message.clone());
        }
    }

    public isolated function delete() returns error? {
        lock {
            self.memory.removeAll();
        }
    }
}
