Declare @orden_excel int = 31731
Declare @orden_DW int	 =(select [ID_DIMORDENFABRICACION]
							FROM [PLDW].[maestro].[DIMORDENFABRICACION] 
							Where COD_REGION_PAIS=7 and COD_ORDEN_FABRICACION= @orden_excel);


with Consumo_Real as (SELECT 
						ID_DIMORDENFABRICACION,
						Cast(ID_DIMARTICULO +1000000 as nvarchar(128)) AS ID_DIMARTICULO,
						SUM(CONSUMO_REAL) AS [Consumo Real],
						SUM(VALOR_COSTO_REAL) AS [Valor Consumo Real ML],
						SUM(VALOR_COSTO_REAL_DOLARES) AS [Valor Consumo Real USD],
						NULL AS [Consumo Estandar],
						NULL AS [Valor Consumo Estandar ML],
						NULL AS [Valor Consumo Estandar USD],
						NULL AS [Horas Real],
						NULL As [Valor Hs Real ML],
						Null As [Valor Hs Real USD],
						NULL AS [Horas Estandar],
						NULL AS [Valor Hs Estandar ML],
						NULL AS [Valor Hs Estandar USD]
					FROM operaciones.FACT_CONSUMO_REAL_DIA
					GROUP BY ID_DIMORDENFABRICACION, ID_DIMARTICULO),
	Consumo_Estandar as (SELECT 
						ID_DIMORDENFABRICACION,
						Cast(ID_DIMARTICULO +1000000 as nvarchar(128)) AS ID_DIMARTICULO,
						NULL as [Consumo Real],
						NULL as [Valor Consumo Real ML],
						NULL as [Valor Consumo Real USD],
						SUM(CONSUMO_ESTANDAR_CANTIDAD_PEDIDA) AS [Consumo Estandar],
						SUM(VALOR_CONSUMO_ESTANDAR) AS [Valor Consumo Estandar ML],
						SUM(VALOR_COSTO_ESTANDAR_DOLARES) AS [Valor Consumo Estandar USD],
						NULL AS [Horas Real],
						NULL As [Valor Hs Real ML],
						Null As [Valor Hs Real USD],
						NULL AS [Horas Estandar],
						NULL AS [Valor Hs Estandar ML],
						NULL AS [Valor Hs Estandar USD]
					FROM operaciones.FACT_CONSUMO_ESTANDAR
					GROUP BY ID_DIMORDENFABRICACION, ID_DIMARTICULO),
	Horas_Real as (SELECT 
						ID_DIMORDENFABRICACION,
						DESCRIPCION AS ID_DIMARTICULO,
						NULL as [Consumo Real],
						NULL as [Valor Consumo Real ML],
						NULL as [Valor Consumo Real USD],
						NULL AS [Consumo Estandar],
						NULL AS [Valor Consumo Estandar ML],
						NULL as [Valor Consumo Estandar USD],
						SUM(OPERACION_HORAS_REAL) as [Horas Real],
						SUM(VALOR_OPERACION_HORAS_REAL) as [Valor Hs Real ML],
						SUM(VALOR_COSTO_HORAS_DOLARES_REAL) AS [Valor Hs Real USD],
						NULL AS [Horas Estandar],
						NULL AS [Valor Hs Estandar ML],
						NULL AS [Valor Hs Estandar USD]
					FROM dbo.HORAS_REAL_FACT_V
					GROUP BY ID_DIMORDENFABRICACION, DESCRIPCION),
	Horas_Estandar as (SELECT 
							ID_DIMORDENFABRICACION,
							DESCRIPCION AS ID_DIMARTICULO,
							NULL as [Consumo Real],
							NULL as [Valor Consumo Real ML],
							NULL as [Valor Consumo Real USD],
							NULL AS [Consumo Estandar],
							NULL AS [Valor Consumo Estandar ML],
							NULL as [Valor Consumo Estandar USD],
							NULL AS [Horas Real],
							NULL As [Valor Hs Real ML],
							Null As [Valor Hs Real USD],
							SUM(VALOR_OPERACION_HORAS_ESTANDAR) AS HorasEstandar,
							SUM(VALOR_COSTO_HORAS_ESTANDAR) AS ValorHorasEstandar,
							SUM(VALOR_COSTO_HORAS_DOLARES_ESTANDAR) AS ValorHorasEstandarUSD
						   FROM PLDW.dbo.HORAS_ESTANDAR_FACT_V
						GROUP BY ID_DIMORDENFABRICACION, DESCRIPCION)

Select fact.*
	   ,b.COD_ORDEN_FABRICACION as [Orden Fabricacion]
	   ,a.[Cod Articulo]
	   ,a.Articulo
	   ,a.COD_CLASEARTICULO
	   ,a.[Clase Articulo]
	   ,a.COD_TIPOARTICULO
	   ,a.[Tipo Articulo]
	   ,a.[AGRUPADOR ARTICULO] as [Agrupador Consumos]
	   
FROM (
    SELECT * FROM Consumo_Real
    UNION ALL
    SELECT * FROM Consumo_Estandar
    UNION ALL
    SELECT * FROM Horas_Real
    UNION ALL
    SELECT * FROM Horas_Estandar
) fact
 
join [maestro].[DIMORDENFABRICACION] b			on b.ID_DIMORDENFABRICACION= fact.ID_DIMORDENFABRICACION
join [dbo].[Clasificacion_Art_Ope_v] a			on a.ID_DIMARTICULO= fact.ID_DIMARTICULO

where fact.ID_DIMORDENFABRICACION= @orden_DW
