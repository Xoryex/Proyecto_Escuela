import { Bot, Send, User, Sparkles, Loader2 } from 'lucide-react';
import React, { useState, useRef, useEffect } from 'react';
import { Toaster, toast } from 'sonner';
import { enviarPregunta } from '../api/chatbotApi';
import type { ChatMessage } from '../types';

const SUGERENCIAS = [
    '¿Cuántos alumnos hay matriculados?',
    '¿Cuáles son los grados disponibles?',
    '¿Cuántos docentes hay por sede?',
    'Mostrar asistencias de hoy',
];

const ChatbotPage: React.FC = () => {
    const [messages, setMessages] = useState<ChatMessage[]>([]);
    const [input, setInput] = useState('');
    const [loading, setLoading] = useState(false);
    const messagesEndRef = useRef<HTMLDivElement>(null);
    const inputRef = useRef<HTMLInputElement>(null);

    const scrollToBottom = () => {
        messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    };

    useEffect(() => {
        scrollToBottom();
    }, [messages]);

    const handleSend = async (text?: string) => {
        const question = (text || input).trim();
        if (!question || loading) return;

        const userMessage: ChatMessage = {
            id: crypto.randomUUID(),
            role: 'user',
            content: question,
            timestamp: new Date(),
        };

        setMessages(prev => [...prev, userMessage]);
        setInput('');
        setLoading(true);

        try {
            const response = await enviarPregunta(question);

            const assistantMessage: ChatMessage = {
                id: crypto.randomUUID(),
                role: 'assistant',
                content: response.error || response.respuesta || 'No se obtuvo respuesta.',
                timestamp: new Date(),
            };

            setMessages(prev => [...prev, assistantMessage]);

            if (response.error) {
                toast.error(response.error);
            }
        } catch {
            const errorMessage: ChatMessage = {
                id: crypto.randomUUID(),
                role: 'assistant',
                content: 'Error al conectar con el asistente. Verifica que el servicio de IA esté activo.',
                timestamp: new Date(),
            };
            setMessages(prev => [...prev, errorMessage]);
            toast.error('Error al conectar con el asistente');
        } finally {
            setLoading(false);
            inputRef.current?.focus();
        }
    };

    const handleKeyDown = (e: React.KeyboardEvent) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            handleSend();
        }
    };

    return (
        <div className="px-3 pt-6 pb-3 sm:px-4 sm:pt-8 sm:pb-4 lg:px-6 lg:pt-8 lg:pb-6 overflow-x-hidden h-[calc(100vh-4rem)] flex flex-col">
            <Toaster position="top-right" richColors />

            {/* Header */}
            <div className="mb-3 lg:mb-4">
                <div className="flex flex-col lg:flex-row lg:justify-between lg:items-center gap-4">
                    <div>
                        <h1 className="text-2xl lg:text-3xl font-bold text-gray-800 flex items-center space-x-3">
                            <Bot className="w-7 h-7 text-escuela" />
                            <span>Asistente IA</span>
                        </h1>
                        <p className="text-gray-600 mt-1 text-sm lg:text-base">
                            Consulta la base de datos en lenguaje natural
                        </p>
                    </div>
                </div>
            </div>

            {/* Chat container */}
            <div className="flex-1 bg-white rounded-lg border border-gray-200 flex flex-col overflow-hidden min-h-0">
                {/* Messages area */}
                <div className="flex-1 overflow-y-auto p-4 space-y-4">
                    {messages.length === 0 && (
                        <div className="flex flex-col items-center justify-center h-full text-center py-12">
                            <div className="w-20 h-20 bg-emerald-100 rounded-full flex items-center justify-center mb-4">
                                <Sparkles className="w-10 h-10 text-escuela" />
                            </div>
                            <h2 className="text-xl font-bold text-gray-800 mb-2">
                                ¡Hola! Soy tu asistente IA
                            </h2>
                            <p className="text-gray-500 max-w-md mb-6">
                                Puedo ayudarte a consultar información de la base de datos usando
                                lenguaje natural. Solo escribe tu pregunta.
                            </p>
                            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 max-w-lg w-full">
                                {SUGERENCIAS.map((sugerencia) => (
                                    <button
                                        key={sugerencia}
                                        onClick={() => handleSend(sugerencia)}
                                        className="text-left px-4 py-3 bg-gray-50 hover:bg-emerald-50 border border-gray-200 hover:border-emerald-300 rounded-lg text-sm text-gray-700 transition-all duration-200"
                                    >
                                        {sugerencia}
                                    </button>
                                ))}
                            </div>
                        </div>
                    )}

                    {messages.map((msg) => (
                        <div
                            key={msg.id}
                            className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'}`}
                        >
                            <div
                                className={`flex items-start gap-2 max-w-[80%] ${
                                    msg.role === 'user' ? 'flex-row-reverse' : ''
                                }`}
                            >
                                {/* Avatar */}
                                <div
                                    className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                                        msg.role === 'user'
                                            ? 'bg-emerald-600'
                                            : 'bg-gray-200'
                                    }`}
                                >
                                    {msg.role === 'user' ? (
                                        <User className="w-4 h-4 text-white" />
                                    ) : (
                                        <Bot className="w-4 h-4 text-gray-600" />
                                    )}
                                </div>

                                {/* Bubble */}
                                <div
                                    className={`px-4 py-3 rounded-2xl text-sm leading-relaxed whitespace-pre-wrap ${
                                        msg.role === 'user'
                                            ? 'bg-emerald-600 text-white rounded-br-md'
                                            : 'bg-gray-100 text-gray-800 rounded-bl-md'
                                    }`}
                                >
                                    {msg.content}
                                </div>
                            </div>
                        </div>
                    ))}

                    {/* Loading indicator */}
                    {loading && (
                        <div className="flex justify-start">
                            <div className="flex items-start gap-2">
                                <div className="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center flex-shrink-0">
                                    <Bot className="w-4 h-4 text-gray-600" />
                                </div>
                                <div className="px-4 py-3 rounded-2xl rounded-bl-md bg-gray-100 flex items-center gap-1">
                                    <Loader2 className="w-4 h-4 text-gray-500 animate-spin" />
                                    <span className="text-sm text-gray-500">Pensando...</span>
                                </div>
                            </div>
                        </div>
                    )}

                    <div ref={messagesEndRef} />
                </div>

                {/* Input area */}
                <div className="border-t border-gray-200 p-4 bg-gray-50">
                    <div className="flex items-center gap-3">
                        <input
                            ref={inputRef}
                            type="text"
                            value={input}
                            onChange={(e) => setInput(e.target.value)}
                            onKeyDown={handleKeyDown}
                            placeholder="Escribe tu pregunta..."
                            disabled={loading}
                            className="flex-1 px-4 py-3 text-sm border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 disabled:opacity-50 disabled:cursor-not-allowed bg-white"
                        />
                        <button
                            onClick={() => handleSend()}
                            disabled={loading || !input.trim()}
                            className="px-5 py-3 bg-gradient-to-r from-escuela to-escuela-light text-white rounded-lg font-semibold hover:shadow-lg transition-all flex items-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed whitespace-nowrap"
                        >
                            <Send className="w-4 h-4" />
                            <span className="hidden sm:inline">Enviar</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default ChatbotPage;
