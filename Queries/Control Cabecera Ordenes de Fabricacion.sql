Declare @orden_excel int =29363
Declare @orden_DW int	 =(select [ID_DIMORDENFABRICACION]
							FROM [PLDW].[maestro].[DIMORDENFABRICACION] 
							Where COD_REGION_PAIS=7 and COD_ORDEN_FABRICACION= @orden_excel);

select	 a.ID_DIMFECHACIERRE as Fecha
		,a.ID_DIMORDENFABRICACION 
		,b.ID_DIMARTICULO 
		,a.COD_ORDEN_FABRICACION as [Orden Fabricacion]
		,c.COD_ARTICULO as [Cod Producto] 
		,c.DESCRIPCION as Producto
		,b.[Produccion Real]
		,b.[Produccion Estandar]
		,b.[Produccion Real Toneladas]
		,b.[Produccion Fardos]
		,e.DESCRIPCION as Instalacion
		,d.COD_CENTROTRABAJO [Cod Centro trabajo]
		,d.DESCRIPCION as Maquina
		,e.COD_REGION_PAIS
		,e.PAIS as Pais
		,d.[PROCESO] as Proceso
		,a.ESTADO as Estado
		,f.COD_TIPOARTICULO as [Cod Tipo Producto]
		,f.DESCRIPCION as [Tipo Producto]
		,g.COD_CLASEARTICULO as [Cod Clase Producto]
		,g.DESCRIPCION as [Clase Producto]

FROM [maestro].[DIMORDENFABRICACION] a

Left join (Select ID_DIMORDENFABRICACION
			,ID_DIMARTICULO
			,sum([PRODUCCION_REAL]) as [Produccion Real]
			,sum([PRODUCCION_REAL_ESTANDAR]) as [Produccion Estandar] 
			,sum([PRODUCCION_REAL_UNIFICADA]) as [Produccion Fardos]
			,sum([PRODUCCION_REAL_TONELADAS_NETA]) as [Produccion Real Toneladas]
			from [PLDW].[operaciones].[FACT_PRODUCCION_REAL_DIA]
			group by ID_DIMORDENFABRICACION, ID_DIMARTICULO) b	on b.ID_DIMORDENFABRICACION= a.ID_DIMORDENFABRICACION and b.ID_DIMARTICULO= a.ID_DIMARTICULO

Left join [maestro].[DIMARTICULO] c										on c.ID_DIMARTICULO= b.ID_DIMARTICULO 
Left join [maestro].[DIMCENTROTRABAJO] d								on d.ID_DIMCENTROTRABAJO= a.ID_DIMCENTROTRABAJO 
left join [dbo].[COMPAÑIA_V] e											on e.ID_DIMINSTALACION= d.[ID_DIMINSTALACION]
Left join [maestro].[DIMTIPOARTICULO] f									on f.ID_DIMTIPOARTICULO= c.ID_DIMTIPOARTICULO 
Left join [maestro].[DIMCLASEARTICULO] g								on g.ID_DIMCLASEARTICULO= c.ID_DIMCLASEARTICULO 

where a.ID_DIMORDENFABRICACION= @orden_DW