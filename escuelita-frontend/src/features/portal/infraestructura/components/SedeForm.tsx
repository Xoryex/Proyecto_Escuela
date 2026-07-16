import { Building2, MapPin, X } from 'lucide-react';
import React, { useEffect, useState } from 'react';
import { escuelaAuthService } from '../../../../services/escuelaAuth.service';
import type { Sede, SedeDTO } from '../types';

interface SedeFormProps {
    sede?: Sede | null;
    onSubmit: (data: SedeDTO) => Promise<void>;
    onCancel: () => void;
    isLoading?: boolean;
}

const SedeForm: React.FC<SedeFormProps> = ({ sede, onSubmit, onCancel, isLoading = false }) => {
    const sedeId = escuelaAuthService.getSedeId();
    const currentUser = escuelaAuthService.getCurrentUser();
    const institucionId = currentUser?.sede?.idInstitucion?.idInstitucion || 0;

    const [activeTab, setActiveTab] = useState<'basica' | 'ubicacion'>('basica');
    const [formData, setFormData] = useState<SedeDTO>({
        nombreSede: '',
        direccion: '',
        distrito: '',
        provincia: '',
        departamento: '',
        ugel: '',
        telefono: '',
        correoInstitucional: '',
        idSede: sedeId || 0,
        idInstitucion: institucionId
    });

    useEffect(() => {
        if (sede) {
            setFormData({
                idSede: sede.idSede,
                nombreSede: sede.nombreSede,
                direccion: sede.direccion || '',
                distrito: sede.distrito || '',
                provincia: sede.provincia || '',
                departamento: sede.departamento || '',
                ugel: sede.ugel || '',
                telefono: sede.telefono || '',
                correoInstitucional: sede.correoInstitucional || '',
                idInstitucion: sede.idInstitucion?.idInstitucion || institucionId
            });
        }
    }, [sede]);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        await onSubmit(formData);
    };

    return (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-2xl max-h-[90vh] overflow-hidden flex flex-col">
                <div className="bg-gradient-to-r from-escuela-light to-escuela-dark p-6 text-white flex justify-between items-center flex-shrink-0">
                    <h2 className="text-xl font-bold flex items-center gap-3">
                        <span className="w-1 h-6 bg-white/70 rounded-full flex-shrink-0"></span>
                        <Building2 className="w-6 h-6" />
                        <span>{sede ? 'Editar Sede' : 'Nueva Sede'}</span>
                    </h2>
                    <button onClick={onCancel} className="p-2 hover:bg-white/20 rounded-lg transition-colors" disabled={isLoading}>
                        <X className="w-5 h-5" />
                    </button>
                </div>

                <form onSubmit={handleSubmit} className="flex flex-col flex-1">
                    <div className="bg-gray-50 border-b border-gray-200 px-6">
                        <div className="flex space-x-1">
                            <button type="button" onClick={() => setActiveTab('basica')}
                                className={`px-5 py-3 font-medium text-sm transition-all ${
                                    activeTab === 'basica'
                                        ? 'border-b-2 border-escuela text-escuela bg-white'
                                        : 'text-gray-500 hover:text-gray-700 hover:bg-gray-100'
                                }`}>
                                <Building2 className="inline w-4 h-4 mr-1.5" />
                                Información Básica
                            </button>
                            <button type="button" onClick={() => setActiveTab('ubicacion')}
                                className={`px-5 py-3 font-medium text-sm transition-all ${
                                    activeTab === 'ubicacion'
                                        ? 'border-b-2 border-escuela text-escuela bg-white'
                                        : 'text-gray-500 hover:text-gray-700 hover:bg-gray-100'
                                }`}>
                                <MapPin className="inline w-4 h-4 mr-1.5" />
                                Ubicación
                            </button>
                        </div>
                    </div>

                    <div className="p-6 overflow-y-auto flex-1">
                        {activeTab === 'basica' && (
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                                <div className="md:col-span-2">
                                    <label className="block text-sm font-medium text-gray-700 mb-1">
                                        Nombre de la Sede <span className="text-red-500">*</span>
                                    </label>
                                    <input type="text" name="nombreSede" value={formData.nombreSede}
                                        onChange={handleChange} required
                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-escuela focus:border-transparent"
                                        placeholder="Ej: Sede Principal" />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">
                                        Teléfono <span className="text-red-500">*</span>
                                    </label>
                                    <input type="tel" name="telefono" value={formData.telefono}
                                        onChange={handleChange} required maxLength={9}
                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-escuela focus:border-transparent"
                                        placeholder="987654321" />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">
                                        Correo Institucional <span className="text-red-500">*</span>
                                    </label>
                                    <input type="email" name="correoInstitucional" value={formData.correoInstitucional}
                                        onChange={handleChange} required
                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-escuela focus:border-transparent"
                                        placeholder="sede@institucion.edu.pe" />
                                </div>
                            </div>
                        )}

                        {activeTab === 'ubicacion' && (
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                                <div className="md:col-span-2">
                                    <label className="block text-sm font-medium text-gray-700 mb-1">
                                        Dirección <span className="text-red-500">*</span>
                                    </label>
                                    <input type="text" name="direccion" value={formData.direccion}
                                        onChange={handleChange} required
                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-escuela focus:border-transparent"
                                        placeholder="Av. Los Héroes 123" />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">
                                        Distrito <span className="text-red-500">*</span>
                                    </label>
                                    <input type="text" name="distrito" value={formData.distrito}
                                        onChange={handleChange} required
                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-escuela focus:border-transparent"
                                        placeholder="Ej: Tarapoto" />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">
                                        Provincia <span className="text-red-500">*</span>
                                    </label>
                                    <input type="text" name="provincia" value={formData.provincia}
                                        onChange={handleChange} required
                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-escuela focus:border-transparent"
                                        placeholder="Ej: San Martín" />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">
                                        Departamento <span className="text-red-500">*</span>
                                    </label>
                                    <input type="text" name="departamento" value={formData.departamento}
                                        onChange={handleChange} required
                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-escuela focus:border-transparent"
                                        placeholder="Ej: San Martín" />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">
                                        UGEL <span className="text-red-500">*</span>
                                    </label>
                                    <input type="text" name="ugel" value={formData.ugel}
                                        onChange={handleChange} required
                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-escuela focus:border-transparent"
                                        placeholder="Ej: UGEL 01" />
                                </div>
                            </div>
                        )}
                    </div>

                    <div className="flex justify-end space-x-3 px-6 py-4 border-t border-gray-200 bg-gray-50">
                        <button type="button" onClick={onCancel} disabled={isLoading}
                            className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors disabled:opacity-50">
                            Cancelar
                        </button>
                        <button type="submit" disabled={isLoading}
                            className="px-6 py-2 bg-gradient-to-r from-escuela to-escuela-light text-white rounded-lg font-semibold hover:shadow-lg transition-all disabled:opacity-50 flex items-center gap-2">
                            {isLoading ? (
                                <><div className="animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent"></div><span>Guardando...</span></>
                            ) : (
                                <span>{sede ? 'Actualizar' : 'Crear'} Sede</span>
                            )}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    );
};

export default SedeForm;