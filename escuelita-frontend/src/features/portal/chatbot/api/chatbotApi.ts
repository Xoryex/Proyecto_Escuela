import { api, API_ENDPOINTS } from '../../../../config/api.config';
import type { ChatbotRespuesta } from '../types';

export const enviarPregunta = async (pregunta: string): Promise<ChatbotRespuesta> => {
    const response = await api.post<ChatbotRespuesta>(API_ENDPOINTS.CHATBOT, { pregunta });
    return response.data;
};
