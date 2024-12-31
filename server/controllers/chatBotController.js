// const { OpenAI } = require("openai");

// const openai = new OpenAI({
//   apiKey: process.env.OPENAI_API_KEY,
// });

// exports.chat = async (req, res) => {
//   const { message } = req.body;

//   try {
//     const response = await openai.chat.completions.create({
//       model: "gpt-3.5-turbo",
//       messages: [{ role: "user", content: message }],
//     });

//     res.json({ response: response.choices[0].message.content.trim() });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ error: "Failed to get a response from the bot" });
//   }
// };
