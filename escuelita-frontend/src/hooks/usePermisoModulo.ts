import { useMemo } from 'react';
import { escuelaAuthService } from '../services/escuelaAuth.service';
import { useModulosPermisos } from './useModulosPermisos';

/**
 * Hook para verificar si el usuario tiene acceso a un módulo específico
 * @param idModulo - ID del módulo
 * @returns boolean - true si tiene acceso, false si no
 * 
 * LÓGICA:
 * - Si es ADMINISTRADOR DE IE: siempre true (acceso total a todos los módulos)
 * - Si es otro rol: verifica si el módulo está asignado a su rol
 * 
 * @example
 * const tieneAcceso = usePermisoModulo(7);
 */
export const usePermisoModulo = (idModulo: number): boolean => {
  const usuarioActual = escuelaAuthService.getCurrentUser();
  const esAdministrador = usuarioActual?.rol?.nombreRol?.toUpperCase() === 'ADMINISTRADOR';
  const tieneSede = !!(usuarioActual && 'sede' in usuarioActual && usuarioActual.sede);

  // Invocar hooks siempre en el mismo orden (cumple React Rules of Hooks)
  const { tieneModulo } = useModulosPermisos(
    esAdministrador && tieneSede ? null : (usuarioActual?.idUsuario || null)
  );

  const tieneAcceso = useMemo(() => {
    if (esAdministrador && tieneSede) {
      return true;
    }
    return tieneModulo(idModulo);
  }, [esAdministrador, tieneSede, tieneModulo, idModulo]);

  return tieneAcceso;
};
