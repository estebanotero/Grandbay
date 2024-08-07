Declare @orden_excel int = 29363
Declare @orden_DW int	 =(select [ID_DIMORDENFABRICACION]
							FROM [PLDW].[maestro].[DIMORDENFABRICACION] 
							Where COD_REGION_PAIS=7 and COD_ORDEN_FABRICACION= @orden_excel);

select a.ID_DIMORDENFABRICACION
	   ,b.COD_ARTICULO
	   ,b.DESCRIPCION
	   ,a.CONSUMO_REAL
	   ,a.VALOR_COSTO
	   ,a.VALOR_COSTO_REAL
	   ,a.VALOR_CONSUMO_REAL
	   ,a.CONSUMO_REAL_TONELADAS
	   ,a.VALOR_COSTO_REAL_DOLARES
FROM operaciones.FACT_CONSUMO_REAL_DIA a
left join [maestro].[DIMARTICULO] b			on b.ID_DIMARTICULO= a.ID_DIMARTICULO
where a.ID_DIMORDENFABRICACION= @orden_DW;
