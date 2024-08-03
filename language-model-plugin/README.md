# languague-model-plugin

Enabled on device inferencing using Mediapipe LLM.

## Install

```bash
npm install languague-model-plugin
npx cap sync
```

## API

<docgen-index>

* [`generate(...)`](#generate)
* [`generateStreaming(...)`](#generatestreaming)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### generate(...)

```typescript
generate(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### generateStreaming(...)

```typescript
generateStreaming(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------

</docgen-api>
