// Enhanced ChatBot Scripts Database with all scenarios
const ChatBotScripts = {
    greeting: {
        patterns: ["xin chào", "hello", "hi", "chào"],
        responses: [
            "Xin chào! Tôi là PenguinBot - trợ lý ảo của PenguinStore. Tôi có thể giúp gì cho bạn hôm nay?",
            "Chào bạn! Tôi có thể hỗ trợ thông tin về sản phẩm, giá cả và đặt hàng. Bạn cần gì ạ?"
        ]
    },
    product_info: {
        patterns: ["thông tin sản phẩm", "giới thiệu sản phẩm", "sản phẩm này có gì", "mô tả"],
        responses: [
            "Chúng tôi có {productName} với các đặc điểm: {description}. Hiện có {stockQuantity} sản phẩm trong kho.",
            "{productName} là sản phẩm {category} với giá {price} VND. {description}",
            "Thông tin chi tiết: {productName} thuộc dòng {typeName}. {description} Hiện đang {discountInfo}"
        ],
        requiredFields: ["productName", "description"]
    },
    product_features: {
        patterns: ["tính năng", "đặc điểm nổi bật", "ưu điểm", "công dụng"],
        responses: [
            "Sản phẩm của chúng tôi có các ưu điểm: {features}. Được làm từ chất liệu {material}.",
            "Điểm nổi bật của {productName}: {keyFeatures}",
            "{productName} có các tính năng chính: {features}. Chất liệu: {material}"
        ]
    },
    discount_info: {
        patterns: ["khuyến mãi", "giảm giá", "discount", "ưu đãi"],
        responses: [
            "Hiện chúng tôi có chương trình {promotionName} giảm {discountPercent}% cho đơn hàng từ {minOrderValue} VND.",
            "Khi mua {productName} bạn sẽ được {discountDetails}. Áp dụng đến {promotionEndDate}",
            "Ưu đãi hiện tại: {promotionDetails} Áp dụng cho {applicableProducts}"
        ]
    },
    how_to_order: {
        patterns: ["cách đặt hàng", "mua như thế nào", "order process", "đặt hàng"],
        responses: [
            "Bạn có thể đặt hàng bằng cách: \n1. Chọn sản phẩm \n2. Thêm vào giỏ \n3. Điền thông tin \n4. Chọn phương thức thanh toán (COD hoặc VNPay) \n5. Xác nhận đơn hàng",
            "Để mua hàng: Thêm sản phẩm vào giỏ > Thanh toán > Chọn hình thức thanh toán (COD/VNPay) > Xác nhận đơn hàng",
            "Quy trình đặt hàng: Chọn sản phẩm > Thêm vào giỏ > Điền thông tin giao hàng > Chọn phương thức thanh toán (COD hoặc VNPay) > Xác nhận đơn"
        ]
    },
    payment_methods: {
        patterns: ["thanh toán", "payment", "chuyển khoản", "trả tiền"],
        responses: [
            "Hiện tại PenguinStore chỉ hỗ trợ 2 phương thức thanh toán: \n1. Thanh toán khi nhận hàng (COD) \n2. Thanh toán qua VNPay",
            "Chúng tôi hiện chỉ chấp nhận: \n- Thanh toán khi nhận hàng (COD) \n- Thanh toán qua cổng VNPay",
            "Bạn có thể chọn một trong hai phương thức: \n• COD (trả tiền khi nhận hàng) \n• Thanh toán online qua VNPay"
        ]
    },
    shipping_info: {
        patterns: ["vận chuyển", "ship", "giao hàng", "thời gian nhận"],
        responses: [
            "Chúng tôi giao hàng toàn quốc với phí vận chuyển từ {shippingFee} VND. Thời gian giao hàng {deliveryTime}",
            "Dịch vụ giao hàng: {shippingOptions}. Thời gian nhận hàng: {deliveryTime}",
            "Phí vận chuyển: {shippingFee} VND. Thời gian giao hàng dự kiến: {deliveryTime}"
        ]
    },
    return_policy: {
        patterns: ["đổi trả", "hoàn hàng", "bảo hành", "return"],
        responses: [
            "Chính sách đổi trả: {returnPolicy}. Thời hạn đổi trả {returnPeriod}",
            "Bảo hành: {warrantyPolicy}. Chính sách đổi trả: {returnPolicy}",
            "Bạn có thể đổi trả sản phẩm trong vòng {returnPeriod} với điều kiện: {returnConditions}"
        ]
    },
    contact_info: {
        patterns: ["liên hệ", "hotline", "email", "địa chỉ"],
        responses: [
            "Bạn có thể liên hệ qua: Hotline {phoneNumber}, Email {email} hoặc địa chỉ {address}",
            "Thông tin liên hệ: SĐT {phoneNumber}, Email {email}. Địa chỉ cửa hàng: {address}",
            "Liên hệ hỗ trợ: {phoneNumber} (8h-22h hàng ngày) hoặc email {email}"
        ]
    }
};
// Hàm trích xuất tên sản phẩm từ câu hỏi
function extractCleanProductName(message) {
    // Xử lý trường hợp có dấu ngoặc kép
    const quotedMatch = message.match(/"([^"]+)"/);
    if (quotedMatch && quotedMatch[1]) {
        return quotedMatch[1].trim();
    }

    // Loại bỏ các từ không cần thiết
    const stopWords = ["giá", "bao nhiêu", "size", "cỡ", "sản phẩm", "có", "cho", "tôi", "biết", "thông tin", "giới thiệu"];
    let cleanName = message.toLowerCase();

    stopWords.forEach(word => {
        const regex = new RegExp('\\b' + word + '\\b', 'gi');
        cleanName = cleanName.replace(regex, '').trim();
    });

    return cleanName.replace(/[",.?]/g, '').trim();
}

// Hàm định dạng tiền tệ
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN').format(amount);
}

// User session handling - Phiên bản đã sửa
function getUserSession() {
    try {
        console.log('Checking user session...', window.userSession);
        if (window.userSession && window.userSession.customerID) {
            console.log('Found session in window.userSession', {
                id: window.userSession.customerID,
                name: window.userSession.fullName || window.userSession.userName,
                fullObject: window.userSession
            });
            return {
                customerId: window.userSession.customerID,
                customerName: window.userSession.fullName || window.userSession.userName || "Khách"
            };
        }
        return {customerId: null, customerName: "Khách"};
    } catch (e) {
        console.error("Error getting user session:", e);
        return {customerId: null, customerName: "Khách"};
    }
}

async function fetchUserSessionFromAPI() {
    try {
        const response = await fetch('/api/getUserSession');
        if (!response.ok)
            throw new Error('Failed to fetch session');

        const user = await response.json();
        if (user && user.customerID) {
            return {
                customerId: user.customerID,
                customerName: user.customerName || user.fullName || "Khách"
            };
        }
    } catch (error) {
        console.error('Error fetching user session:', error);
    }
    return {
        customerId: null,
        customerName: "Khách"
    };
}


async function searchProductAndGetPrice(message) {
    try {
        const productName = extractCleanProductName(message);
        if (!productName) {
            return "Vui lòng cung cấp tên sản phẩm rõ ràng hơn";
        }

        console.log("Searching for product:", productName);

        const response = await fetch(`/PenguinStore/Products/ChatBot/Search?q=${encodeURIComponent(productName)}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            credentials: 'include' // Quan trọng: gửi cả session cookie nếu có
        });

        console.log("API response status:", response.status);

        if (!response.ok) {
            const error = await response.text();
            console.error("API error:", error);
            return "Hiện không thể truy vấn thông tin sản phẩm. Vui lòng thử lại sau.";
        }

        const products = await response.json();
        console.log("Received products:", products);

        if (!products || products.length === 0) {
            return `Xin lỗi, không tìm thấy sản phẩm "${productName}" trong cửa hàng`;
        }

        // Lấy sản phẩm phù hợp nhất
        const product = products[0];

        // Tạo response chi tiết
        let responseText = `Thông tin sản phẩm "${product.productName}":\n\n`;
        responseText += `- Giá: ${formatCurrency(product.price)} VNĐ\n`;
        responseText += `- Khuyến mãi: ${product.isSale ? "Đang giảm giá" : "Không có khuyến mãi"}\n`;

        if (product.availableSizes) {
            responseText += `- Size có sẵn: ${product.availableSizes}\n`;
        }

        if (product.availableColors) {
            responseText += `- Màu sắc: ${product.availableColors}\n`;
        }

        responseText += `- Tồn kho: ${product.stockTotal} sản phẩm\n`;

        if (product.description) {
            responseText += `- Mô tả: ${product.description}\n`;
        }

        return responseText;

    } catch (error) {
        console.error("Error searching product:", error);
        return "Xin lỗi, có lỗi khi tìm kiếm thông tin sản phẩm";
    }
}


// PenguinChatBot Class
class PenguinChatBot {
    constructor(scripts) {
        this.scripts = scripts;
        this.context = {
            currentProduct: null,
            conversationHistory: [
                {
                    role: "system",
                    content: "Bạn là PenguinBot, trợ lý ảo thân thiện cho cửa hàng PenguinStore. " +
                            "Hãy trả lời ngắn gọn, nhiệt tình bằng tiếng Việt. " +
                            "Nếu không chắc chắn, hãy hỏi lại khách hàng để làm rõ yêu cầu."
                }
            ]
        };
    }

    async respondTo(message) {
        // Add to conversation history
        this.context.conversationHistory.push({role: "user", content: message});

        // Detect intent
        const intent = this.detectIntent(message);

        // First try predefined scripts
        const scriptResponse = this.tryPredefinedScripts(message, intent);
        if (scriptResponse && !scriptResponse.includes("Xin lỗi")) {
            return scriptResponse;
        }

        // Nếu không có script phù hợp, trả về null để xử lý tiếp
        return null;
    }

    async fetchProducts(query) {
        try {
            const response = await fetch(`PenguinStore/Products/ChatBot/Searchh?q=${encodeURIComponent(query)}`);
            if (!response.ok)
                throw new Error(`HTTP error! status: ${response.status}`);
            return await response.json();
        } catch (error) {
            console.error("Error fetching products:", error);
            return [];
        }
    }

    shouldUseAI(intent) {
        // Không gọi AI cho các intent đã có kịch bản
        const handledIntents = [
            "greeting",
            "payment_methods",
            "how_to_order",
            "shipping_info",
            "return_policy",
            "contact_info"
        ];
        return !handledIntents.includes(intent.type);
    }

    detectIntent(message) {
        const lowerMsg = message.toLowerCase();

        const paymentPatterns = ["thanh toán", "payment", "chuyển khoản", "trả tiền"];
        if (paymentPatterns.some(pattern => lowerMsg.includes(pattern))) {
            return {type: "payment_methods", requiresProduct: false};
        }

        // Check greeting first
        if (this.scripts.greeting.patterns.some(pattern => lowerMsg.includes(pattern))) {
            return {type: "greeting", requiresProduct: false};
        }

        // Check other intents
        for (const [scriptKey, script] of Object.entries(this.scripts)) {
            if (scriptKey !== "greeting" && script.patterns.some(pattern => lowerMsg.includes(pattern))) {
                return {
                    type: scriptKey,
                    requiresProduct: scriptKey.includes("product") || scriptKey.includes("price")
                };
            }
        }

        return {type: "general", requiresProduct: false};
    }

    tryPredefinedScripts(message, intent) {
        const script = this.scripts[intent.type];

        if (script && (!intent.requiresProduct || this.context.currentProduct)) {
            const randomResponse = script.responses[Math.floor(Math.random() * script.responses.length)];

            if (script.requiredFields && this.context.currentProduct) {
                const missingFields = script.requiredFields.filter(
                        field => !this.context.currentProduct[field]
                );

                if (missingFields.length > 0) {
                    return `Xin lỗi, tôi không có đủ thông tin về ${missingFields.join(", ")} của sản phẩm này.`;
                }
            }

            return intent.requiresProduct
                    ? this.fillTemplate(randomResponse, this.context.currentProduct)
                    : randomResponse;
        }

        return null;
    }

    fillTemplate(template, data) {
        const fullData = {
            discountInfo: data.isSale ? "đang được giảm giá" : "không có khuyến mãi",
            promotionDetails: data.isSale ? "Hiện đang có chương trình khuyến mãi" : "",
            stockQuantity: data.stockQuantity || "nhiều",
            ...data
        };

        return Object.entries(fullData).reduce((result, [key, value]) => {
            const placeholder = new RegExp(`{${key}}`, 'g');
            return result.replace(placeholder, value || "");
        }, template);
    }

    async generateAIResponse(message, intent) {
        const prompt = {
            model: "llama3-8b-8192",
            messages: [
                ...this.context.conversationHistory,
                {
                    role: "system",
                    content: this.createAIContextPrompt(intent)
                }
            ],
            temperature: 0.7,
            max_tokens: 500
        };

        try {
            const response = await fetch("https://api.groq.com/openai/v1/chat/completions", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": `Bearer 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`
                },
                body: JSON.stringify(prompt)
            });

            if (!response.ok) {
                throw new Error(`API request failed with status ${response.status}`);
            }

            const data = await response.json();
            const aiResponse = data.choices[0].message.content.trim();

            // Save response to history
            this.context.conversationHistory.push({role: "assistant", content: aiResponse});

            return aiResponse;
        } catch (error) {
            console.error("API call error:", error);
            throw error;
        }
    }

    createAIContextPrompt(intent) {
        let prompt = "Context: ";

        if (this.context.currentProduct) {
            prompt += `Current product: ${JSON.stringify(this.context.currentProduct)}. `;
        }

        switch (intent.type) {
            case "price_inquiry":
                prompt += "Focus on providing accurate pricing and discount information.";
                break;
            case "product_info":
                prompt += "Focus on product features and specifications.";
                break;
            case "how_to_order":
                prompt += "Explain the ordering process step by step.";
                break;
            default:
                prompt += "Provide helpful and friendly response.";
        }

        return prompt;
    }
}

// Initialize PenguinChatBot
const chatbotInstance = new PenguinChatBot(ChatBotScripts);


// Sử dụng khi gửi tin nhắn chatbot
const sendChatMessage = async (message) => {
    // Ưu tiên xử lý cục bộ trước
    const scriptResponse = await chatbotInstance.respondTo(message);
    if (scriptResponse && !scriptResponse.includes("Xin lỗi, tôi không hiểu")) {
        return scriptResponse;
    }

    // Xử lý các câu hỏi về sản phẩm
    if (message.toLowerCase().includes("giá") ||
            message.toLowerCase().includes("size") ||
            message.toLowerCase().includes("màu") ||
            message.toLowerCase().includes("giới thiệu") ||
            message.toLowerCase().includes("tồn kho")) {
        const productResponse = await searchProductAndGetPrice(message);
        if (productResponse && !productResponse.includes("Không tìm thấy")) {
            return productResponse;
        }
    }
    // Chỉ gọi AI bên ngoài cho các câu hỏi không có trong kịch bản
    try {
        const {customerName: currentCustomerName} = getUserSession();

        const response = await fetch("https://api.groq.com/openai/v1/chat/completions", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer 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`
            },
            body: JSON.stringify({
                model: "llama3-8b-8192",
                messages: [
                    {
                        role: "system",
                        content: `Bạn là PenguinBot, trợ lý ảo cho cửa hàng PenguinStore. 
                                 Chỉ sử dụng thông tin sau về phương thức thanh toán:
                                 "Chúng tôi chỉ hỗ trợ 2 phương thức: Thanh toán khi nhận hàng (COD) và thanh toán qua VNPay"
                                 KHÔNG được đề cập bất kỳ phương thức thanh toán nào khác.
                                 Người dùng hiện tại: ${currentCustomerName || "Khách"}`
                    },
                    {
                        role: "user",
                        content: message
                    }
                ],
                temperature: 0.3, // Giảm nhiệt độ để trả lời chính xác hơn
                max_tokens: 200
            })
        });

        const data = await response.json();
        return data.choices[0].message.content;
    } catch (error) {
        console.error("Lỗi API chatbot:", error);
        return "Xin lỗi, tôi gặp sự cố khi xử lý yêu cầu của bạn.";
    }
};

// ChatBot Implementation
document.addEventListener("DOMContentLoaded", async function () {
    // DOM Elements
    const chatbotContainer = document.querySelector(".chatbot-container");
    const chatbotToggler = document.querySelector(".chatbot-toggler");
    const chatbot = document.querySelector(".chatbot");
    const chatbox = document.querySelector(".chatbox");
    const chatInput = document.querySelector(".chat-input textarea");
    const sendChatBtn = document.querySelector(".chat-input span");
    const closeBtn = document.querySelector(".close-btn");
    const inputInitHeight = chatInput.scrollHeight;

    // User session handling
    let customerId = null;
    let customerName = "Khách";

    try {
        // Get user session - now async
        const session = await getUserSession();
        customerId = session.customerId;
        customerName = session.customerName;

        console.log("User session initialized:", {customerId, customerName});
    } catch (e) {
        console.error("Error loading user session:", e);
    }


    // Create chat message element
    const createChatLi = (message, className) => {
        const chatLi = document.createElement("li");
        chatLi.classList.add("chat", className);

        let chatContent = className === "outgoing"
                ? `<p>${message}</p>`
                : `<span class="mdi mdi-penguin"></span><p>${message}</p>`;

        chatLi.innerHTML = chatContent;
        return chatLi;
    };

    // Save chat history
    const saveChatHistory = async (customerId, customerName, question, answer) => {
        try {
            // Use absolute path to avoid context path issues
            const response = await fetch("/PenguinStore/api/chatbot/save", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json", // Must match backend
                },
                body: JSON.stringify({
                    customerId: customerId,
                    customerName: customerName,
                    question: question,
                    answer: answer
                })
            });

            if (!response.ok) {
                const error = await response.text();
                throw new Error(`HTTP error! status: ${response.status}, ${error}`);
            }

            return await response.json();
        } catch (error) {
            console.error("Error saving chat:", error);
            throw error;
        }
    };

    // Handle chat message
    const handleChat = async () => {
        const userMessage = chatInput.value.trim();
        if (!userMessage)
            return;

        // Clear input và reset height
        chatInput.value = "";
        chatInput.style.height = `${inputInitHeight}px`;

        // Thêm tin nhắn người dùng vào chatbox
        chatbox.appendChild(createChatLi(userMessage, "outgoing"));
        chatbox.scrollTo(0, chatbox.scrollHeight);

        // Hiển thị tin nhắn "đang xử lý"
        const incomingChatLi = createChatLi("", "incoming");
        chatbox.appendChild(incomingChatLi);

        // Cập nhật trạng thái xử lý dựa trên đăng nhập
        incomingChatLi.querySelector("p").textContent = !customerId
                ? "Đang xử lý... (Bạn đang chat với tư cách khách)"
                : "Đang xử lý...";

        chatbox.scrollTo(0, chatbox.scrollHeight);

        try {
            // Gọi API chatbot để nhận phản hồi
            const botResponse = await sendChatMessage(userMessage);

            // Cập nhật phản hồi thực tế
            incomingChatLi.querySelector("p").textContent = botResponse;

            // Chỉ lưu lịch sử nếu đã đăng nhập
            if (customerId) {
                try {
                    await saveChatHistory(customerId, customerName, userMessage, botResponse);
                } catch (saveError) {
                    console.error("Failed to save chat:", saveError);
                    // Show user-friendly error message
                    incomingChatLi.querySelector("p").textContent +=
                            "\n\n(Lưu lịch sử chat không thành công)";
                }
            }
        } catch (error) {
            incomingChatLi.querySelector("p").textContent = "Xin lỗi, tôi gặp sự cố khi xử lý yêu cầu của bạn.";
            incomingChatLi.querySelector("p").classList.add("error");
            console.error("Lỗi chatbot:", error);
        }

        chatbox.scrollTo(0, chatbox.scrollHeight);
    };

    // Event listeners
    chatInput.addEventListener("input", () => {
        chatInput.style.height = `${inputInitHeight}px`;
        chatInput.style.height = `${chatInput.scrollHeight}px`;
    });

    chatInput.addEventListener("keydown", (e) => {
        if (e.key === "Enter" && !e.shiftKey) {
            e.preventDefault();
            handleChat();
        }
    });

    sendChatBtn.addEventListener("click", handleChat);
    chatbotToggler.addEventListener("click", () => {
        document.body.classList.toggle("show-chatbot");
    });
    closeBtn.addEventListener("click", () => {
        document.body.classList.remove("show-chatbot");
    });
});