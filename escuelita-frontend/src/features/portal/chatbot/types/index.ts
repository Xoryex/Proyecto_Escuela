export interface ChatbotPregunta {
    pregunta: string;
}

export interface ChatbotRespuesta {
    respuesta?: string;
    error?: string;
}

export interface ChatMessage {
    id: string;
    role: 'user' | 'assistant';
    content: string;
    timestamp: Date;
}
