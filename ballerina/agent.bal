// Copyright (c) 2025 WSO2 LLC (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

public type SystemPrompt record {|
    string role;
    string instructions;
    string...;
|};

public enum AgentType {
    REACT_AGENT,
    FUNCTION_CALL_AGENT
}

public type AgentConfiguration record {|
    SystemPrompt systemPrompt;
    Model model;
    (BaseToolKit|ToolConfig|FunctionTool)[] tools = [];
    AgentType agentType = FUNCTION_CALL_AGENT;
    int maxIter = 5;
    boolean verbose = false;
|};

public isolated distinct client class Agent {
    private final BaseAgent agent;
    private final int maxIter;
    private final readonly & SystemPrompt systemPrompt;
    private final boolean verbose;

    public isolated function init(*AgentConfiguration config) returns Error? {
        self.maxIter = config.maxIter;
        self.verbose = config.verbose;
        self.systemPrompt = config.systemPrompt.cloneReadOnly();
        self.agent = config.agentType is REACT_AGENT ? check new ReActAgent(config.model, config.tools)
            : check new FunctionCallAgent(config.model, config.tools);
    }

    isolated remote function run(string query) returns string|Error {
        var result = self.agent->run(query, self.maxIter, getFomatedSystemPrompt(self.systemPrompt), self.verbose);
        return result.answer ?: "";
    }
}

isolated function getFomatedSystemPrompt(SystemPrompt systemPrompt) returns string {

    string otherDetails = "";
    foreach [string, string] [name, value] in systemPrompt.entries() {
        if name == "role" || name == "instructions" {
            continue;
        }
        otherDetails += "\n" + name + ":\n" + value + "\n";
    }

    return string `
You are an AI agent with the following responsibility: ${systemPrompt.role}

Please follow these instructions:
${systemPrompt.instructions}

${otherDetails}`;
}
