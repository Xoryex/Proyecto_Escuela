import { Building2, Edit, MapPin, Plus, Star, Trash2 } from 'lucide-react';
import React, { useEffect, useMemo, useState } from 'react';
import { toast, Toaster } from 'sonner';
import Pagination from '../../../../components/common/Pagination';
import { escuelaAuthService } from '../../../../services/escuelaAuth.service';
import SedeForm from '../components/SedeForm';
import { useSedes } from '../hooks/useInfraestructura';
import type { Sede } from '../types';

const SedesPage: React.FC = () => {
    const sedeId = escuelaAuthService.getSedeId();
    const currentUser = escuelaAuthService.getCurrentUser();

    const { registros: sedes, cargando, obtenerTodos: obtenerSedes, crear, actualizar, eliminar } = useSedes();

    const [showModal, setShowModal] = useState(false);
    const [sedeSeleccionada, setSedeSeleccionada] = useState<Sede | null>(null);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [searchTerm, setSearchTerm] = useState('');
    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 10;

    useEffect(() => {
        obtenerSedes();
    }, []);

    const sedesFiltradas = useMemo(() => {
        if (!searchTerm.trim()) return sedes;
        const term = searchTerm.toLowerCase();
        return sedes.filter(s =>
            s.nombreSede.toLowerCase().includes(term) ||
            s.distrito?.toLowerCase().includes(term) ||
            s.provincia?.toLowerCase().includes(term) ||
            s.departamento?.toLowerCase().includes(term)
        );
    }, [sedes, searchTerm]);

    const totalPages = Math.ceil(sedesFiltradas.length / itemsPerPage);
    const sedesPaginadas = sedesFiltradas.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

    useEffect(() => { setCurrentPage(1); }, [searchTerm]);

    const handleSubmit = async (data: any) => {
        setIsSubmitting(true);
        try {
            if (sedeSeleccionada) {
                await actualizar({ ...data, idSede: sedeSeleccionada.idSede });
                toast.success('Sede actualizada exitosamente');
            } else {
                await crear(data);
                toast.success('Sede creada exitosamente');
            }
            setShowModal(false);
            setSedeSeleccionada(null);
        } catch (err: any) {
            const msg = err?.response?.data || err?.message || '';
            toast.error(msg || (sedeSeleccionada ? 'Error al actualizar la sede' : 'Error al crear la sede'));
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleEliminar = async (id: number) => {
        if (window.confirm('¿Está seguro de eliminar esta sede?')) {
            try {
                await eliminar(id);
                toast.success('Sede eliminada exitosamente');
            } catch {
                toast.error('Error al eliminar la sede');
            }
        }
    };

    return (
        <div className="p-3 sm:p-4 lg:px-6 lg:py-4">
            <Toaster position="top-right" richColors />

            <div className="mb-6 pt-6">
                <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
                    <div>
                        <h1 className="text-2xl font-bold text-gray-800 flex items-center gap-2.5">
                            <div className="w-9 h-9 rounded-xl bg-escuela/10 flex items-center justify-center">
                                <Building2 className="w-5 h-5 text-escuela" />
                            </div>
                            Sedes
                        </h1>
                        <p className="text-gray-400 text-sm mt-1">Gestiona las sedes de tu institución educativa.</p>
                    </div>
                    <button
                        onClick={() => { setSedeSeleccionada(null); setShowModal(true); }}
                        className="px-6 py-2.5 bg-gradient-to-r from-escuela to-escuela-light text-white rounded-lg font-semibold hover:shadow-lg transition-all flex items-center gap-2 whitespace-nowrap"
                    >
                        <Plus className="w-4 h-4" />
                        <span>Nueva Sede</span>
                    </button>
                </div>
            </div>

            {/* Búsqueda */}
            <div className="mb-4">
                <input
                    type="text"
                    value={searchTerm}
                    onChange={e => setSearchTerm(e.target.value)}
                    placeholder="Buscar por nombre, distrito, provincia..."
                    className="w-full sm:max-w-md px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-escuela focus:border-transparent text-sm"
                />
            </div>

            {/* Tabla */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                <div className="overflow-x-auto">
                    <table className="w-full">
                        <thead>
                            <tr className="bg-gray-50/80">
                                <th className="px-5 py-3 text-left text-[11px] font-semibold text-gray-400 uppercase tracking-wider">Sede</th>
                                <th className="px-5 py-3 text-left text-[11px] font-semibold text-gray-400 uppercase tracking-wider">Principal</th>
                                <th className="px-5 py-3 text-left text-[11px] font-semibold text-gray-400 uppercase tracking-wider">Ubicación</th>
                                <th className="px-5 py-3 text-left text-[11px] font-semibold text-gray-400 uppercase tracking-wider">Contacto</th>
                                <th className="px-5 py-3 text-center text-[11px] font-semibold text-gray-400 uppercase tracking-wider">Acciones</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-50">
                            {cargando ? (
                                <tr>
                                    <td colSpan={5} className="px-5 py-12 text-center">
                                        <div className="animate-spin rounded-full h-7 w-7 border-[3px] border-escuela border-t-transparent mx-auto"></div>
                                        <p className="text-xs text-gray-400 mt-3">Cargando sedes...</p>
                                    </td>
                                </tr>
                            ) : sedesPaginadas.length === 0 ? (
                                <tr>
                                    <td colSpan={5} className="px-5 py-12 text-center">
                                        <Building2 className="w-10 h-10 text-gray-200 mx-auto mb-3" />
                                        <p className="text-sm text-gray-400">{searchTerm ? 'No se encontraron sedes' : 'No hay sedes registradas'}</p>
                                    </td>
                                </tr>
                            ) : (
                                sedesPaginadas.map(sede => (
                                    <tr key={sede.idSede} className="hover:bg-gray-50/50 transition-colors">
                                        <td className="px-5 py-3.5">
                                            <div className="flex items-center gap-3">
                                                <div className="w-9 h-9 rounded-xl bg-escuela/10 flex items-center justify-center">
                                                    <Building2 className="w-4 h-4 text-escuela" />
                                                </div>
                                                <span className="font-semibold text-gray-800 text-sm">{sede.nombreSede}</span>
                                            </div>
                                        </td>
                                        <td className="px-5 py-3.5">
                                            {sede.esSedePrincipal ? (
                                                <span className="inline-flex items-center gap-1 text-yellow-600 text-xs font-medium">
                                                    <Star className="w-3.5 h-3.5 fill-current" />
                                                    Principal
                                                </span>
                                            ) : (
                                                <span className="text-xs text-gray-400">Anexo</span>
                                            )}
                                        </td>
                                        <td className="px-5 py-3.5">
                                            <div className="flex items-start gap-1.5">
                                                <MapPin className="w-3.5 h-3.5 text-gray-400 flex-shrink-0 mt-0.5" />
                                                <div className="text-xs text-gray-500">
                                                    {sede.direccion && <div>{sede.direccion}</div>}
                                                    <div>{sede.distrito}, {sede.provincia}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td className="px-5 py-3.5">
                                            <div className="text-xs text-gray-500">
                                                <div>{sede.telefono}</div>
                                                <div className="text-gray-400">{sede.correoInstitucional}</div>
                                            </div>
                                        </td>
                                        <td className="px-5 py-3.5">
                                            <div className="flex items-center justify-center gap-1">
                                                <button
                                                    onClick={() => { setSedeSeleccionada(sede); setShowModal(true); }}
                                                    className="p-2 text-escuela hover:bg-escuela/10 rounded-lg transition-all"
                                                    title="Editar"
                                                >
                                                    <Edit className="w-4 h-4" />
                                                </button>
                                                <button
                                                    onClick={() => handleEliminar(sede.idSede)}
                                                    className="p-2 text-red-400 hover:bg-red-50 rounded-lg transition-all"
                                                    title="Eliminar"
                                                >
                                                    <Trash2 className="w-4 h-4" />
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                ))
                            )}
                        </tbody>
                    </table>
                </div>
                {!cargando && totalPages > 1 && (
                    <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />
                )}
            </div>

            {/* Modal */}
            {showModal && (
                <SedeForm
                    sede={sedeSeleccionada}
                    onSubmit={handleSubmit}
                    onCancel={() => { setShowModal(false); setSedeSeleccionada(null); }}
                    isLoading={isSubmitting}
                />
            )}
        </div>
    );
};

export default SedesPage;