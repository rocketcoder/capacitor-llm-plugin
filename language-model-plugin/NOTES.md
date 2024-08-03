### .podspec

    # Add your dependencies here
    s.dependency 'MediaPipeTasksGenAI', '~> 0.10.14'
    s.dependency 'MediaPipeTasksGenAIC' , '~> 0.10.14'
  
    s.static_framework = false

### ./src/definitions.ts and web.ts
definitions.ts defines the interface and web.ts provides an implementation.  For web we recommend using an llm api like chat-gpt or gemini.  Not currenly implimented.

### build

npm run build