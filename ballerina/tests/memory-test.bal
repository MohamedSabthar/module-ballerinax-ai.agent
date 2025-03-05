import ballerina/test;

@test:Config {}
function testMemoryInitialization() returns error? {
    MessageWindowChatMemory chatMemory = new (5);
    ChatMessage[] history = check chatMemory.get();
    int memoryLength = history.length(); 
    test:assertEquals(memoryLength, 0);
}

@test:Config {}
function testMemoryUpdateSystemMesage() returns error? {
    MessageWindowChatMemory chatMemory = new (5);
    ChatUserMessage userMessage = { role: "user", content: "Hi im bob" };
    _ = check chatMemory.update(userMessage);
    ChatAssistantMessage assistantMessage = { role: "assistant", content: "Hello Bob! How can I assist you today?" };
    _ = check chatMemory.update(assistantMessage);
    ChatSystemMessage systemMessage = { role: "system", content: "You are an AI assistant to help users get answers. Respond to the human as helpfully and accurately as possible"};
    _ = check chatMemory.update(systemMessage);
    ChatMessage[] history = check chatMemory.get();
    test:assertEquals(history[0], systemMessage);
}

@test:Config {}
function testUpdateExceedMemorySize() returns error? {
    MessageWindowChatMemory chatMemory = new (3);
    ChatUserMessage userMessage = { role: "user", content: "Hi im bob" };
    _ = check chatMemory.update(userMessage);
    ChatAssistantMessage assistantMessage = { role: "assistant", content: "Hello Bob! How can I assist you today?" };
    _ = check chatMemory.update(assistantMessage);
    ChatSystemMessage systemMessage = { role: "system", content: "You are an AI assistant to help users get answers. Respond to the human as helpfully and accurately as possible"};
    _ = check chatMemory.update(systemMessage);
    ChatUserMessage userMessage2 = { role: "user", content: "Add teh numbers [2,3,4,5]" };
    _ = check chatMemory.update(userMessage2);
    ChatMessage[] history = check chatMemory.get();
    test:assertEquals(history[0], systemMessage); 
    test:assertEquals(history[1], assistantMessage);
    test:assertEquals(history.length(), 3); 
}

@test:Config {}
function testClearMemory() returns error? {
    MessageWindowChatMemory chatMemory = new (4);
    ChatUserMessage userMessage = { role: "user", content: "Hi im bob" };
    _ = check chatMemory.update(userMessage);
    ChatAssistantMessage assistantMessage = { role: "assistant", content: "Hello Bob! How can I assist you today?" };
    _ = check chatMemory.update(assistantMessage);
    ChatSystemMessage systemMessage = { role: "system", content: "You are an AI assistant to help users get answers. Respond to the human as helpfully and accurately as possible"};
    _ = check chatMemory.update(systemMessage);
    _ = check chatMemory.delete();
    test:assertEquals(chatMemory.get(), []);
}

@test:Config {}
function testClearEmptyMemory() returns error? {
    MessageWindowChatMemory chatMemory = new (4);
    _ = check chatMemory.delete();
    test:assertEquals(chatMemory.get(), []);
}

// MessageWindowChatMemory memoryInstance = new (10);



// memoryInstance.systemPrompt = { role: "system", content: "You are an AI assistant to help users get answers. Respond to the human as helpfully and accurately as possible" };

// memoryInstance.memory = [
//     { role: "assistant", content: "Hello Aakif! How can I assist you today?" },
//     { role: "user", content: "Add teh numbers [2,3,4,5]" },
//     { role: "assistant", content: null, function_call: { name: "sum", arguments: "{ \"numbers\": [2, 3, 4, 5] }" } },
//     { role: "function", content: "Answer is: 14.0", name: "sum" },
//     { role: "assistant", content: "The sum of the numbers [2, 3, 4, 5] is 14.0. If you need anything else, let me know!" },
//     { role: "user", content: "Mutiply teh number obtained after addition by 2. Tell the answer by adressing me in my name" },
//     { role: "assistant", content: null, function_call: { name: "mutiply", arguments: "{ \"a\": 14, \"b\": 2 }" } },
//     { role: "function", content: "Answer is: 28", name: "mutiply" },
//     { role: "assistant", content: "The result of multiplying the sum by 2 is 28, Aakif. If you have any more questions or need further assistance, feel free to ask!" }
// ];